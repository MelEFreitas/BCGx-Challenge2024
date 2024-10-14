import 'package:frontend/domain/entities/user/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class UserModel {
  UserModel({required this.email, required this.role});

  final String email;
  final String role;

  // Default empty user to avoid null cases
  static final empty = UserModel(
    email: '',
    role: '',
  );

  UserEntity toEntity() {
    return UserEntity(
      email: email,
      role: role,
    );
  }

  static UserModel fromEntity(UserEntity entity) {
    return UserModel(
      email: entity.email,
      role: entity.role,
    );
  }

  // Factory constructor for creating a new instance from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return _$UserModelFromJson(json);
  }

  // Regular method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return _$UserModelToJson(this);
  }
}
