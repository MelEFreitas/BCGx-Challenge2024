import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.userId,
    required this.email,
    required this.name,
  });

  final String userId;
  final String email;
  final String name;

  @override
  String toString() {
    return 'UserEntity: $userId, $email, $name';
  }

  @override
  List<Object?> get props => [userId, email, name];
}