/// A model representing a request to delete a chat.
///
/// This class encapsulates the data required to identify a chat
/// that needs to be deleted, specifically the unique identifier
/// for the chat.
///
/// Attributes:
/// - [chatId]: The unique identifier of the chat to be deleted.
///
/// This class does not include methods for serialization since
/// it primarily serves as a data container.
class DeleteChatReq {
  /// Creates an instance of [DeleteChatReq].
  ///
  /// Requires [chatId] to be provided.
  DeleteChatReq({required this.chatId});

  /// The unique identifier of the chat to be deleted.
  final String chatId;
}
