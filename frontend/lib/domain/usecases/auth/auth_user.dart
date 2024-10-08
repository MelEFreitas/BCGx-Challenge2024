import 'package:dartz/dartz.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/core/usecase/usecase.dart';
import 'package:frontend/data/models/auth/auth_user_req.dart';
import 'package:frontend/domain/entities/user/user.dart';
import 'package:frontend/domain/repositories/auth/auth.dart';
import 'package:frontend/service_locator.dart';

class AuthUserUseCase
    implements UseCase<Either<Failure, UserEntity>, AuthUserReq> {
  @override
  Future<Either<Failure, UserEntity>> call(
      {required AuthUserReq params}) async {
    return sl<AuthRepository>().authUser(params);
  }
}
