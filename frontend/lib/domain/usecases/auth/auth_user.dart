import 'package:dartz/dartz.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/core/usecase/usecase.dart';
import 'package:frontend/domain/entities/user/user.dart';
import 'package:frontend/domain/repositories/auth/auth.dart';
import 'package:frontend/service_locator.dart';

/// Use case for authenticating a user.
///
/// This use case encapsulates the logic for retrieving the authenticated user's information.
/// It uses the [AuthRepository] to perform the authentication operation.
class AuthUserUseCase implements UseCase<Either<Failure, UserEntity>, void> {
  /// Calls the authentication operation to retrieve the user information.
  ///
  /// This method does not require any parameters and returns a [Future] that
  /// resolves to an [Either] containing a [Failure] in case of an error,
  /// or a [UserEntity] if the operation is successful.
  @override
  Future<Either<Failure, UserEntity>> call({void params}) async {
    return sl<AuthRepository>().authUser();
  }
}
