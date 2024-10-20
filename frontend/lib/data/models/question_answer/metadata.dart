import 'package:frontend/domain/entities/question_answer/metadata.dart';
import 'package:json_annotation/json_annotation.dart';

part 'metadata.g.dart';

/// Model class representing metadata associated with a question and answer.
///
/// This model includes the page number and file name where the relevant
/// information was found. It is serializable to and from JSON.
@JsonSerializable()
class MetadataModel {
  /// Creates a new [MetadataModel] instance.
  ///
  /// The [pageNumber] and [fileName] parameters are required, but they can
  /// be `null`.
  MetadataModel({required this.pageNumber, required this.fileName});

  /// The page number where the relevant information was found.
  @JsonKey(name: 'page_number')
  final String? pageNumber;

  /// The file name from which the relevant information was retrieved.
  @JsonKey(name: 'file_name')
  final String? fileName;

  /// Converts this [MetadataModel] into a [MetadataEntity].
  ///
  /// Returns a new [MetadataEntity] object with the same properties as
  /// this model.
  MetadataEntity toEntity() {
    return MetadataEntity(
      pageNumber: pageNumber,
      fileName: fileName,
    );
  }

  /// Creates a [MetadataModel] from a [MetadataEntity].
  ///
  /// If the provided [entity] is `null`, the model will be initialized
  /// with `null` values for [pageNumber] and [fileName].
  static MetadataModel fromEntity(MetadataEntity? entity) {
    return MetadataModel(
      pageNumber: entity?.pageNumber,
      fileName: entity?.fileName,
    );
  }

  /// Factory constructor for creating a new instance from a JSON map.
  ///
  /// This constructor takes a [Map<String, dynamic>] as input and
  /// returns a new [MetadataModel] instance, mapping the JSON keys
  /// to the model's attributes.
  factory MetadataModel.fromJson(Map<String, dynamic> json) {
    return _$MetadataModelFromJson(json);
  }

  /// Converts the [MetadataModel] instance to a JSON map.
  ///
  /// Returns a [Map<String, dynamic>] containing the serialized
  /// properties of the model.
  Map<String, dynamic> toJson() {
    return _$MetadataModelToJson(this);
  }
}
