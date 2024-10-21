/// Represents a summary of a chat in the application.
///
/// This entity holds essential information about a chat, such as
/// the chat identifier and its title.
class ChatSummaryEntity {
  /// Creates an instance of [ChatSummaryEntity].
  ///
  /// The [chatId] and [title] are required parameters that represent
  /// the unique identifier of the chat and the title of the chat,
  /// respectively.
  ChatSummaryEntity({required this.chatId, required this.title});

  /// The unique identifier for the chat.
  final String chatId;

  /// The title of the chat.
  final String title;

  @override
  String toString() {
    return 'ChatSummaryEntity(chatId: $chatId, title: $title)';
  }
}
