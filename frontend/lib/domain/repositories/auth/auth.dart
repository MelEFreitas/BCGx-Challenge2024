import 'package:dartz/dartz.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/domain/entities/user/user.dart';

abstract class AuthRepository {
  Future<void> signOut();
  Future<Either<Failure, void>> signIn();
  Future<Either<Failure, UserEntity>> signUp();
}