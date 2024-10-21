import 'package:frontend/domain/entities/chat/chat_summary.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_summary.g.dart';

/// A model representing a summary of a chat.
///
/// This class provides a representation of chat summaries, supporting
/// serialization and deserialization to and from JSON format.
///
/// Attributes:
/// - [chatId]: The unique identifier for the chat.
/// - [title]: The title of the chat.
///
/// This model includes methods to convert between the [ChatSummaryEntity]
/// and [ChatSummaryModel] representations and to handle JSON serialization.
@JsonSerializable()
class ChatSummaryModel {
  /// Creates an instance of [ChatSummaryModel].
  ///
  /// Requires [chatId] and [title] to be provided.
  ChatSummaryModel({required this.chatId, required this.title});

  /// The unique identifier for the chat.
  @JsonKey(name: 'id')
  final String chatId;

  /// The title of the chat.
  final String title;

  /// Converts the [ChatSummaryModel] instance to a [ChatSummaryEntity].
  ///
  /// Returns a [ChatSummaryEntity] containing the chatId and title.
  ChatSummaryEntity toEntity() {
    return ChatSummaryEntity(
      chatId: chatId,
      title: title,
    );
  }

  /// Converts a [ChatSummaryEntity] instance to a [ChatSummaryModel].
  ///
  /// Takes a [ChatSummaryEntity] and returns a corresponding [ChatSummaryModel].
  static ChatSummaryModel fromEntity(ChatSummaryEntity entity) {
    return ChatSummaryModel(
      chatId: entity.chatId,
      title: entity.title,
    );
  }

  /// Factory constructor for creating a new instance from JSON.
  ///
  /// Takes a [Map<String, dynamic>] as input and returns a
  /// [ChatSummaryModel] instance.
  factory ChatSummaryModel.fromJson(Map<String, dynamic> json) {
    return _$ChatSummaryModelFromJson(json);
  }

  /// Converts the [ChatSummaryModel] instance to JSON.
  ///
  /// Returns a [Map<String, dynamic>] containing the chatId and title
  /// serialized in JSON format.
  Map<String, dynamic> toJson() {
    return _$ChatSummaryModelToJson(this);
  }
}
