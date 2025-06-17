import 'package:equatable/equatable.dart';

class ChabotState extends Equatable {
  final List<Map<String, String>> messages;
  final List<List<Map<String, String>>> savedConversations;
  final bool isLoadingResponse;
  final String? errorMessage;

  const ChabotState({
    required this.messages,
    required this.savedConversations,
    this.isLoadingResponse = false,
    this.errorMessage,
  });

  factory ChabotState.initial() => const ChabotState(
        messages: [],
        savedConversations: [],
        isLoadingResponse: false,
        errorMessage: null,
      );

  ChabotState copyWith({
    List<Map<String, String>>? messages,
    List<List<Map<String, String>>>? savedConversations,
    bool? isLoadingResponse,
    String? errorMessage,
  }) {
    return ChabotState(
      messages: messages ?? this.messages,
      savedConversations: savedConversations ?? this.savedConversations,
      isLoadingResponse: isLoadingResponse ?? this.isLoadingResponse,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [messages, savedConversations, isLoadingResponse, errorMessage];
} 