// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'question_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionAnswerModel _$QuestionAnswerModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'QuestionAnswerModel',
      json,
      ($checkedConvert) {
        final val = QuestionAnswerModel(
          question: $checkedConvert('question', (v) => v as String),
          answer: $checkedConvert('answer', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$QuestionAnswerModelToJson(
        QuestionAnswerModel instance) =>
    <String, dynamic>{
      'question': instance.question,
      'answer': instance.answer,
    };
