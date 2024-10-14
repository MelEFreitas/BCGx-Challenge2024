import 'package:dartz/dartz.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/core/usecase/usecase.dart';
import 'package:frontend/data/models/auth/sign_in_req.dart';
import 'package:frontend/domain/repositories/auth/auth.dart';
import 'package:frontend/service_locator.dart';

class SignInUseCase implements UseCase<Either<Failure, void>, SignInReq> {
  @override
  Future<Either<Failure, void>> call({required SignInReq params}) async {
    return sl<AuthRepository>().signIn(params);
  }
}
