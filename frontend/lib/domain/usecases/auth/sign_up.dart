import 'package:dartz/dartz.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/core/usecase/usecase.dart';
import 'package:frontend/data/models/auth/sign_up_req.dart';
import 'package:frontend/domain/repositories/auth/auth.dart';
import 'package:frontend/service_locator.dart';

class SignUpUseCase implements UseCase<Either<Failure, void>, SignUpReq> {
  @override
  Future<Either<Failure, void>> call({required SignUpReq params}) async {
    return sl<AuthRepository>().signUp(params);
  }
}
