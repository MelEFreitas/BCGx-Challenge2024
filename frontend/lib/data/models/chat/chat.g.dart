// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatModel _$ChatModelFromJson(Map<String, dynamic> json) => $checkedCreate(
      'ChatModel',
      json,
      ($checkedConvert) {
        final val = ChatModel(
          id: $checkedConvert('id', (v) => v as String),
          title: $checkedConvert('title', (v) => v as String),
          conversation: $checkedConvert(
              'conversation',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      QuestionAnswerModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$ChatModelToJson(ChatModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'conversation': instance.conversation,
    };
