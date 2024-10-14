import 'package:frontend/data/models/question_answer/question_answer.dart';
import 'package:frontend/domain/entities/chat/chat.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat.g.dart';

@JsonSerializable()
class ChatModel {
  ChatModel(
      {required this.id, required this.title, required this.conversation});

  final int id;
  final String title;
  final List<QuestionAnswerModel> conversation;

  ChatEntity toEntity() {
    return ChatEntity(
      id: id,
      title: title,
      conversation: conversation.map((qa) => qa.toEntity()).toList(),
    );
  }

  static ChatModel fromEntity(ChatEntity entity) {
    return ChatModel(
      id: entity.id,
      title: entity.title,
      conversation: entity.conversation
          .map((qa) => QuestionAnswerModel.fromEntity(qa))
          .toList(),
    );
  }

  // Factory constructor for creating a new instance from JSON
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return _$ChatModelFromJson(json);
  }

  // Regular method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return _$ChatModelToJson(this);
  }
}
