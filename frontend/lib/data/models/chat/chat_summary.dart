import 'package:frontend/domain/entities/chat/chat_summary.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_summary.g.dart';

@JsonSerializable()
class ChatSummaryModel {
  ChatSummaryModel({required this.chatId, required this.title});

  @JsonKey(name: 'id')
  final int chatId;
  final String title;

  ChatSummaryEntity toEntity() {
    return ChatSummaryEntity(
      chatId: chatId,
      title: title,
    );
  }

  static ChatSummaryModel fromEntity(ChatSummaryEntity entity) {
    return ChatSummaryModel(
      chatId: entity.chatId,
      title: entity.title,
    );
  }

  // Factory constructor for creating a new instance from JSON
  factory ChatSummaryModel.fromJson(Map<String, dynamic> json) {
    return _$ChatSummaryModelFromJson(json);
  }

  // Regular method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return _$ChatSummaryModelToJson(this);
  }
}
