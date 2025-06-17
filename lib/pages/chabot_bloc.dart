import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'chabot_event.dart';
import 'chabot_state.dart';

class ChabotBloc extends Bloc<ChabotEvent, ChabotState> {
  http.Client? _httpClient;
  StreamSubscription<String>? _responseSubscription;

  ChabotBloc() : super(ChabotState.initial()) {
    on<SendMessageEvent>(_onSendMessage);
    on<StartNewChatEvent>(_onStartNewChat);
    on<LoadConversationEvent>(_onLoadConversation);
    on<DeleteConversationEvent>(_onDeleteConversation);
  }

  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChabotState> emit) async {
    if (state.isLoadingResponse) return;
    final question = event.message.trim();
    if (question.isEmpty) return;

    final updatedMessages = List<Map<String, String>>.from(state.messages)
      ..add({"role": "user", "content": question});
    emit(state.copyWith(messages: updatedMessages, isLoadingResponse: true, errorMessage: null));

    try {
      _httpClient = http.Client();
      final uri = Uri.parse("http://localhost:11434/api/chat");
      final headers = {"Content-Type": "application/json"};
      final body = {"model": "tinydolphin", "messages": updatedMessages};

      final request = http.Request('POST', uri)
        ..headers.addAll(headers)
        ..body = json.encode(body);

      final newMessages = List<Map<String, String>>.from(updatedMessages)
        ..add({"role": "assistant", "content": ""});
      emit(state.copyWith(messages: newMessages));

      final response = await _httpClient!.send(request);
      final completer = Completer<void>();
      _responseSubscription = response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
        (String line) {
          if (line.isNotEmpty) {
            try {
              final jsonResponse = json.decode(line);
              if (jsonResponse['message'] != null &&
                  jsonResponse['message']['content'] != null) {
                final content = jsonResponse['message']['content'];
                final updated = List<Map<String, String>>.from(state.messages);
                updated.last['content'] = (updated.last['content'] ?? '') + content;
                if (!emit.isDone) emit(state.copyWith(messages: updated));
              }
            } catch (_) {}
          }
        },
        onDone: () {
          if (!emit.isDone) emit(state.copyWith(isLoadingResponse: false));
          completer.complete();
        },
        onError: (error) {
          final updated = List<Map<String, String>>.from(state.messages);
          updated.last['content'] = (updated.last['content'] ?? '') + "\nError: ${error.toString()}";
          if (!emit.isDone) emit(state.copyWith(messages: updated, isLoadingResponse: false));
          completer.complete();
        },
      );
      await completer.future;
    } catch (err) {
      final updated = List<Map<String, String>>.from(state.messages)
        ..add({"role": "assistant", "content": "Failed to connect to the chatbot service. Error: $err"});
      if (!emit.isDone) emit(state.copyWith(messages: updated, isLoadingResponse: false));
    }
  }

  void _onStartNewChat(StartNewChatEvent event, Emitter<ChabotState> emit) {
    final updatedSaved = List<List<Map<String, String>>>.from(state.savedConversations);
    if (state.messages.isNotEmpty) {
      updatedSaved.add(List.from(state.messages));
    }
    emit(state.copyWith(messages: [], savedConversations: updatedSaved));
  }

  void _onLoadConversation(LoadConversationEvent event, Emitter<ChabotState> emit) {
    final loaded = List<Map<String, String>>.from(state.savedConversations[event.index]);
    emit(state.copyWith(messages: loaded));
  }

  void _onDeleteConversation(DeleteConversationEvent event, Emitter<ChabotState> emit) {
    final updatedSaved = List<List<Map<String, String>>>.from(state.savedConversations)
      ..removeAt(event.index);
    emit(state.copyWith(savedConversations: updatedSaved));
  }

  @override
  Future<void> close() {
    _responseSubscription?.cancel();
    _httpClient?.close();
    return super.close();
  }
} 