/// A model representing a request to retrieve a chat.
///
/// This class encapsulates the data required to identify a specific
/// chat that needs to be fetched, specifically the unique identifier
/// for the chat.
///
/// Attributes:
/// - [chatId]: The unique identifier of the chat to be retrieved.
///
/// This class serves as a data container and does not include methods
/// for serialization, focusing solely on representing the request.
class GetChatReq {
  /// Creates an instance of [GetChatReq].
  ///
  /// Requires [chatId] to be provided.
  GetChatReq({required this.chatId});

  /// The unique identifier of the chat to be retrieved.
  final String chatId;
}
