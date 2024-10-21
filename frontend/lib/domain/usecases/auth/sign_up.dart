import 'package:dartz/dartz.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/core/usecase/usecase.dart';
import 'package:frontend/data/models/auth/sign_up_req.dart';
import 'package:frontend/domain/repositories/auth/auth.dart';
import 'package:frontend/service_locator.dart';

/// Use case for signing up a new user.
///
/// This use case encapsulates the logic for registering a new user
/// in the system. It interacts with the [AuthRepository] to
/// perform the sign-up operation.
class SignUpUseCase implements UseCase<Either<Failure, void>, SignUpReq> {
  /// Calls the sign-up operation with the provided [SignUpReq] parameters.
  ///
  /// Returns a [Future] that resolves to an [Either] containing a [Failure]
  /// in case of an error, or `void` if the sign-up operation is successful.
  @override
  Future<Either<Failure, void>> call({required SignUpReq params}) async {
    return sl<AuthRepository>().signUp(params);
  }
}
