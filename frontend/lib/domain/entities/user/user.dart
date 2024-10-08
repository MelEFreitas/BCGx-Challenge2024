import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.email,
    required this.role,
  });

  final String email;
  final String role;

  @override
  String toString() {
    return 'UserEntity: $email, $role';
  }

  @override
  List<Object?> get props => [email, role];
}
