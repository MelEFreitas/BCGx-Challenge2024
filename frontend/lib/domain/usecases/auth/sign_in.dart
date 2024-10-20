import 'package:dartz/dartz.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/core/usecase/usecase.dart';
import 'package:frontend/data/models/auth/sign_in_req.dart';
import 'package:frontend/domain/repositories/auth/auth.dart';
import 'package:frontend/service_locator.dart';

/// Use case for signing in a user.
///
/// This use case encapsulates the logic for authenticating a user
/// using their credentials. It interacts with the [AuthRepository]
/// to perform the sign-in operation.
class SignInUseCase implements UseCase<Either<Failure, void>, SignInReq> {
  /// Calls the sign-in operation with the provided [SignInReq] parameters.
  ///
  /// Returns a [Future] that resolves to an [Either] containing a [Failure]
  /// in case of an error, or `void` if the sign-in operation is successful.
  @override
  Future<Either<Failure, void>> call({required SignInReq params}) async {
    return sl<AuthRepository>().signIn(params);
  }
}
