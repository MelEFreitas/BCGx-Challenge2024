import 'package:frontend/domain/entities/question_answer/question_answer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'question_answer.g.dart';

@JsonSerializable()
class QuestionAnswerModel {
  QuestionAnswerModel({required this.question, required this.answer});

  final String question;
  final String answer;

  QuestionAnswerEntity toEntity() {
    return QuestionAnswerEntity(
      question: question,
      answer: answer,
    );
  }

  static QuestionAnswerModel fromEntity(QuestionAnswerEntity entity) {
    return QuestionAnswerModel(
      question: entity.question,
      answer: entity.answer,
    );
  }

  // Factory constructor for creating a new instance from JSON
  factory QuestionAnswerModel.fromJson(Map<String, dynamic> json) {
    return _$QuestionAnswerModelFromJson(json);
  }

  // Regular method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return _$QuestionAnswerModelToJson(this);
  }
}
