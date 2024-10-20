import 'package:frontend/domain/entities/user/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// A model representing a user in the application.
///
/// This class provides a representation of user data, including email
/// and role, and supports serialization and deserialization to and
/// from JSON format.
///
/// Attributes:
/// - [email]: The email address of the user.
/// - [role]: The role assigned to the user in the system.
///
/// This model includes methods to convert between the [UserEntity] and
/// [UserModel] representations and to handle JSON serialization.
@JsonSerializable()
class UserModel {
  /// Creates an instance of [UserModel].
  ///
  /// Requires [email] and [role] to be provided.
  UserModel({required this.email, required this.role});

  /// The email address of the user.
  final String email;

  /// The role assigned to the user.
  final String role;

  /// A static constant representing an empty user to avoid null cases.
  static final empty = UserModel(
    email: '',
    role: '',
  );

  /// Converts the [UserModel] instance to a [UserEntity].
  ///
  /// Returns a [UserEntity] containing the email and role.
  UserEntity toEntity() {
    return UserEntity(
      email: email,
      role: role,
    );
  }

  /// Converts a [UserEntity] instance to a [UserModel].
  ///
  /// Takes a [UserEntity] and returns a corresponding [UserModel].
  static UserModel fromEntity(UserEntity entity) {
    return UserModel(
      email: entity.email,
      role: entity.role,
    );
  }

  /// Factory constructor for creating a new instance from JSON.
  ///
  /// Takes a [Map<String, dynamic>] as input and returns a
  /// [UserModel] instance.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return _$UserModelFromJson(json);
  }

  /// Converts the [UserModel] instance to JSON.
  ///
  /// Returns a [Map<String, dynamic>] containing the email and role
  /// serialized in JSON format.
  Map<String, dynamic> toJson() {
    return _$UserModelToJson(this);
  }
}
