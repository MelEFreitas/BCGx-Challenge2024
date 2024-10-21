/// A model representing a request to update an existing chat.
///
/// This class encapsulates the data required to identify a specific
/// chat that needs to be updated, as well as the new question
/// to be associated with that chat.
///
/// Attributes:
/// - [chatId]: The unique identifier of the chat to be updated.
/// - [question]: The new question to set for the chat.
///
/// The class provides a method to convert the instance to a map,
/// which can be useful for serialization or network requests.
class UpdateChatReq {
  /// Creates an instance of [UpdateChatReq].
  ///
  /// Requires [chatId] and [question] to be provided.
  UpdateChatReq({required this.chatId, required this.question});

  /// The unique identifier of the chat to be updated.
  final String chatId;

  /// The new question to set for the chat.
  final String question;

  /// Converts the [UpdateChatReq] instance to a map.
  ///
  /// Returns a [Map<String, dynamic>] containing the question.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{'question': question};
  }
}
