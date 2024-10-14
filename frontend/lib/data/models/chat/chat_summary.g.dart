// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'chat_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatSummaryModel _$ChatSummaryModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ChatSummaryModel',
      json,
      ($checkedConvert) {
        final val = ChatSummaryModel(
          chatId: $checkedConvert('id', (v) => (v as num).toInt()),
          title: $checkedConvert('title', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'chatId': 'id'},
    );

Map<String, dynamic> _$ChatSummaryModelToJson(ChatSummaryModel instance) =>
    <String, dynamic>{
      'id': instance.chatId,
      'title': instance.title,
    };
