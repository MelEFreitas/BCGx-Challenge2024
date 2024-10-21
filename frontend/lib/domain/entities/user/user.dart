import 'package:equatable/equatable.dart';

/// Represents a user in the application.
///
/// This entity contains the user's email and role, 
/// and is used for user authentication and authorization purposes.
class UserEntity extends Equatable {
  /// Creates an instance of [UserEntity].
  ///
  /// The [email] and [role] are required parameters representing
  /// the user's email and role respectively.
  const UserEntity({
    required this.email,
    required this.role,
  });

  /// The user's email address.
  final String email;

  /// The user's role within the application.
  final String role;

  @override
  String toString() {
    return 'UserEntity: email = $email, role = $role';
  }

  @override
  List<Object?> get props => [email, role];
}
