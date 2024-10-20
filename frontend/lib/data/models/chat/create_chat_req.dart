/// A model representing a request to create a new chat.
///
/// This class encapsulates the data required to initiate a chat,
/// specifically the initial question to start the conversation.
///
/// Attributes:
/// - [question]: The initial question to be posed in the chat.
///
/// The class provides a method to convert the instance to a map,
/// which can be useful for serialization or network requests.
class CreateChatReq {
  /// Creates an instance of [CreateChatReq].
  ///
  /// Requires [question] to be provided.
  CreateChatReq({required this.question});

  /// The initial question to be posed in the chat.
  final String question;

  /// Converts the [CreateChatReq] instance to a map.
  ///
  /// Returns a [Map<String, dynamic>] containing the question.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{'question': question};
  }
}
