import 'package:dartz/dartz.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/core/usecase/usecase.dart';
import 'package:frontend/domain/entities/user/user.dart';
import 'package:frontend/domain/repositories/auth/auth.dart';
import 'package:frontend/service_locator.dart';

class AuthUserUseCase implements UseCase<Either<Failure, UserEntity>, void> {
  @override
  Future<Either<Failure, UserEntity>> call({void params}) async {
    return sl<AuthRepository>().authUser();
  }
}
