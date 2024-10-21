// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => $checkedCreate(
      'UserModel',
      json,
      ($checkedConvert) {
        final val = UserModel(
          email: $checkedConvert('email', (v) => v as String),
          role: $checkedConvert('role', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'email': instance.email,
      'role': instance.role,
    };
