// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetadataModel _$MetadataModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'MetadataModel',
      json,
      ($checkedConvert) {
        final val = MetadataModel(
          pageNumber: $checkedConvert('page_number', (v) => v as String?),
          fileName: $checkedConvert('file_name', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'pageNumber': 'page_number', 'fileName': 'file_name'},
    );

Map<String, dynamic> _$MetadataModelToJson(MetadataModel instance) =>
    <String, dynamic>{
      'page_number': instance.pageNumber,
      'file_name': instance.fileName,
    };
