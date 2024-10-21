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
          metadata: $checkedConvert(
              'answer_metadata',
              (v) => (v as List<dynamic>?)
                  ?.map(
                      (e) => MetadataModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
      fieldKeyMap: const {'metadata': 'answer_metadata'},
    );

Map<String, dynamic> _$QuestionAnswerModelToJson(
        QuestionAnswerModel instance) =>
    <String, dynamic>{
      'question': instance.question,
      'answer': instance.answer,
      'answer_metadata': instance.metadata,
    };
