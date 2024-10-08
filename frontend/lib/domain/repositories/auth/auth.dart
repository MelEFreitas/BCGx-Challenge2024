import 'package:dartz/dartz.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/data/models/auth/auth_user_req.dart';
import 'package:frontend/data/models/auth/sign_in_req.dart';
import 'package:frontend/data/models/auth/sign_up_req.dart';
import 'package:frontend/domain/entities/user/user.dart';

abstract class AuthRepository {
  Future<void> signOut();
  Future<Either<Failure, String>> signIn(SignInReq req);
  Future<Either<Failure, void>> signUp(SignUpReq req);
  Future<Either<Failure, UserEntity>> authUser(AuthUserReq req);
}
