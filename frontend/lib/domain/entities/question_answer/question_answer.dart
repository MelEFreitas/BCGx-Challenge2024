/// Represents a question and its corresponding answer.
///
/// This entity is used to hold a single question-answer pair in a conversation.
class QuestionAnswerEntity {
  /// Creates an instance of [QuestionAnswerEntity].
  ///
  /// The [question] and [answer] are required parameters representing
  /// the question and its respective answer.
  QuestionAnswerEntity({
    required this.question,
    required this.answer,
  });

  /// The question being asked.
  final String question;

  /// The answer to the question.
  final String answer;

  @override
  String toString() {
    return 'QuestionAnswerEntity(question: $question, answer: $answer)';
  }
}
