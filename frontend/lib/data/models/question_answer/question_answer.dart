import 'package:frontend/data/models/question_answer/metadata.dart';
import 'package:frontend/domain/entities/question_answer/question_answer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'question_answer.g.dart';

/// A model representing a question and its corresponding answer.
///
/// This class provides a representation of question-answer pairs,
/// supporting serialization and deserialization to and from JSON format.
///
/// Attributes:
/// - [question]: The text of the question.
/// - [answer]: The text of the answer.
///
/// This model includes methods to convert between the [QuestionAnswerEntity]
/// and [QuestionAnswerModel] representations and to handle JSON serialization.
@JsonSerializable()
class QuestionAnswerModel {
  /// Creates an instance of [QuestionAnswerModel].
  ///
  /// Requires [question] and [answer] to be provided.
  QuestionAnswerModel({required this.question, required this.answer, required this.metadata});

  /// The text of the question.
  final String question;

  /// The text of the answer.
  final String answer;

  @JsonKey(name: 'answer_metadata')
  final List<MetadataModel>? metadata;

  /// Converts the [QuestionAnswerModel] instance to a [QuestionAnswerEntity].
  ///
  /// Returns a [QuestionAnswerEntity] containing the question and answer.
  QuestionAnswerEntity toEntity() {
    return QuestionAnswerEntity(
      question: question,
      answer: answer,
      metadata: metadata?.map((m) => m.toEntity()).toList(),
    );
  }

  /// Converts a [QuestionAnswerEntity] instance to a [QuestionAnswerModel].
  ///
  /// Takes a [QuestionAnswerEntity] and returns a corresponding [QuestionAnswerModel].
  static QuestionAnswerModel fromEntity(QuestionAnswerEntity entity) {
    return QuestionAnswerModel(
      question: entity.question,
      answer: entity.answer,
      metadata: entity.metadata?.map((m) => MetadataModel.fromEntity(m)).toList(),
    );
  }

  /// Factory constructor for creating a new instance from JSON.
  ///
  /// Takes a [Map<String, dynamic>] as input and returns a
  /// [QuestionAnswerModel] instance.
  factory QuestionAnswerModel.fromJson(Map<String, dynamic> json) {
    return _$QuestionAnswerModelFromJson(json);
  }

  /// Converts the [QuestionAnswerModel] instance to JSON.
  ///
  /// Returns a [Map<String, dynamic>] containing the question and answer
  /// serialized in JSON format.
  Map<String, dynamic> toJson() {
    return _$QuestionAnswerModelToJson(this);
  }
}
