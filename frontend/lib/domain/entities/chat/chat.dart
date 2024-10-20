import 'package:frontend/domain/entities/question_answer/question_answer.dart';

/// Represents a chat in the application.
///
/// This entity holds essential information about a chat, including
/// the unique identifier, title, and the conversation history.
class ChatEntity {
  /// Creates an instance of [ChatEntity].
  ///
  /// The [id], [title], and [conversation] are required parameters
  /// that represent the unique identifier of the chat, the title of
  /// the chat, and the list of question-answer pairs in the conversation,
  /// respectively.
  ChatEntity({
    required this.id,
    required this.title,
    required this.conversation,
  });

  /// The unique identifier for the chat.
  final String id;

  /// The title of the chat.
  final String title;

  /// The conversation history, represented as a list of question-answer pairs.
  final List<QuestionAnswerEntity> conversation;

  @override
  String toString() {
    return 'ChatEntity(id: $id, title: $title, conversation: $conversation)';
  }
}
