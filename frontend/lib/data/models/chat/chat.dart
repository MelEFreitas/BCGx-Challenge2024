import 'package:frontend/data/models/question_answer/question_answer.dart';
import 'package:frontend/domain/entities/chat/chat.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat.g.dart';

/// A model representing a chat conversation.
///
/// This class provides a representation of a chat, including its
/// unique identifier, title, and a list of question-answer pairs
/// that make up the conversation.
///
/// Attributes:
/// - [id]: The unique identifier for the chat.
/// - [title]: The title of the chat.
/// - [conversation]: A list of question-answer pairs that form the chat's
/// conversation.
///
/// This model includes methods to convert between the [ChatEntity]
/// and [ChatModel] representations and to handle JSON serialization.
@JsonSerializable()
class ChatModel {
  /// Creates an instance of [ChatModel].
  ///
  /// Requires [id], [title], and [conversation] to be provided.
  ChatModel(
      {required this.id, required this.title, required this.conversation});

  /// The unique identifier for the chat.
  final String id;

  /// The title of the chat.
  final String title;

  /// A list of question-answer pairs that form the chat's conversation.
  final List<QuestionAnswerModel> conversation;

  /// Converts the [ChatModel] instance to a [ChatEntity].
  ///
  /// Returns a [ChatEntity] containing the id, title, and a mapped list
  /// of question-answer entities from the conversation.
  ChatEntity toEntity() {
    return ChatEntity(
      id: id,
      title: title,
      conversation: conversation.map((qa) => qa.toEntity()).toList(),
    );
  }

  /// Converts a [ChatEntity] instance to a [ChatModel].
  ///
  /// Takes a [ChatEntity] and returns a corresponding [ChatModel].
  static ChatModel fromEntity(ChatEntity entity) {
    return ChatModel(
      id: entity.id,
      title: entity.title,
      conversation: entity.conversation
          .map((qa) => QuestionAnswerModel.fromEntity(qa))
          .toList(),
    );
  }

  /// Factory constructor for creating a new instance from JSON.
  ///
  /// Takes a [Map<String, dynamic>] as input and returns a
  /// [ChatModel] instance.
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return _$ChatModelFromJson(json);
  }

  /// Converts the [ChatModel] instance to JSON.
  ///
  /// Returns a [Map<String, dynamic>] containing the id, title, and
  /// conversation serialized in JSON format.
  Map<String, dynamic> toJson() {
    return _$ChatModelToJson(this);
  }
}
