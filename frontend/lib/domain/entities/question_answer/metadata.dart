/// Entity class representing metadata associated with a question and answer.
///
/// This class holds information about the page number and file name where
/// the relevant data is found. It is used as a domain entity.
class MetadataEntity {
  /// Creates a new [MetadataEntity] instance.
  ///
  /// The [pageNumber] and [fileName] parameters are required, but they can be
  /// `null` to account for cases where this information is unavailable.
  MetadataEntity({required this.pageNumber, required this.fileName});

  /// The page number where the relevant information is found.
  ///
  /// This can be `null` if the page number is unknown or not applicable.
  final String? pageNumber;

  /// The file name from which the relevant information is retrieved.
  ///
  /// This can be `null` if the file name is unknown or not applicable.
  final String? fileName;

  /// Returns a string representation of the [MetadataEntity] object.
  ///
  /// The [toString] method provides a formatted string that includes
  /// both the [pageNumber] and [fileName] attributes.
  @override
  String toString() {
    return 'Metadata(pageNumber: $pageNumber, fileName: $fileName)';
  }
}
