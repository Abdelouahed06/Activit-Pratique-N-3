import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chabot_bloc.dart';
import 'chabot_event.dart';
import 'chabot_state.dart';

class ChabotPage extends StatefulWidget {
  const ChabotPage({super.key});

  @override
  State<ChabotPage> createState() => _ChabotPageState();
}

class _ChabotPageState extends State<ChabotPage> {
  final TextEditingController _userController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _userController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => ChabotBloc(),
      child: BlocConsumer<ChabotBloc, ChabotState>(
        listener: (context, state) {
          _scrollToBottom();
        },
        builder: (context, state) {
          return Scaffold(
            key: _scaffoldKey,
            drawer: Drawer(
              child: Column(
                children: [
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Saved Conversations',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: state.savedConversations.isEmpty
                        ? Center(
                            child: Text(
                              'No saved conversations',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: state.savedConversations.length,
                            itemBuilder: (context, index) {
                              final conversation = state.savedConversations[index];
                              String preview = "New Chat";
                              if (conversation.isNotEmpty &&
                                  conversation[0]['content']!.isNotEmpty) {
                                preview = conversation[0]['content']!.substring(
                                    0,
                                    min(conversation[0]['content']!.length, 30));
                                if (conversation[0]['content']!.length > 30) {
                                  preview += "...";
                                }
                              }
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.withOpacity(0.1),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: ListTile(
                                  dense: true,
                                  leading: const Icon(Icons.chat_bubble_outline, size: 20),
                                  title: Text(
                                    'Conversation ${index + 1}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    preview,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  onTap: () {
                                    context.read<ChabotBloc>().add(LoadConversationEvent(index));
                                    Navigator.pop(context);
                                  },
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline, size: 18),
                                    onPressed: () {
                                      context.read<ChabotBloc>().add(DeleteConversationEvent(index));
                                    },
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
            appBar: AppBar(
              title: Text(
                "DWM Chatbot",
                style: TextStyle(color: theme.indicatorColor),
              ),
              backgroundColor: theme.primaryColor,
              leading: IconButton(
                icon: Icon(Icons.menu, color: theme.indicatorColor),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/");
                  },
                  icon: Icon(Icons.logout, color: theme.indicatorColor),
                ),
                IconButton(
                  onPressed: () {
                    context.read<ChabotBloc>().add(StartNewChatEvent());
                  },
                  icon: Icon(Icons.note_add, color: theme.indicatorColor),
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: state.messages.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat,
                                size: 64,
                                color: theme.hintColor,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Start a new conversation",
                                style: TextStyle(
                                  color: theme.hintColor,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            final message = state.messages[index];
                            final isUser = message['role'] == 'user';
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Align(
                                alignment: isUser
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                                  ),
                                  child: Card(
                                    color: isUser
                                        ? theme.primaryColor.withOpacity(0.1)
                                        : isDarkMode
                                            ? Colors.grey[800]
                                            : Colors.white,
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(16),
                                        topRight: const Radius.circular(16),
                                        bottomLeft: isUser
                                            ? const Radius.circular(16)
                                            : const Radius.circular(4),
                                        bottomRight: isUser
                                            ? const Radius.circular(4)
                                            : const Radius.circular(16),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                        message['content']!,
                                        style: TextStyle(
                                          color: isUser
                                              ? theme.primaryColor
                                              : theme.textTheme.bodyLarge?.color,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                if (state.isLoadingResponse)
                  const LinearProgressIndicator(
                    minHeight: 2,
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _userController,
                          decoration: InputDecoration(
                            hintText: "Type a message...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () {
                                final text = _userController.text.trim();
                                if (text.isNotEmpty && !state.isLoadingResponse) {
                                  context.read<ChabotBloc>().add(SendMessageEvent(text));
                                  _userController.clear();
                                }
                              },
                            ),
                          ),
                          onSubmitted: (_) {
                            final text = _userController.text.trim();
                            if (text.isNotEmpty && !state.isLoadingResponse) {
                              context.read<ChabotBloc>().add(SendMessageEvent(text));
                              _userController.clear();
                            }
                          },
                          textInputAction: TextInputAction.send,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}