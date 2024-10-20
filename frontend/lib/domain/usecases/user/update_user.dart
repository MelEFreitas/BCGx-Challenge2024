import 'package:dartz/dartz.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/core/usecase/usecase.dart';
import 'package:frontend/data/models/user/update_user_req.dart';
import 'package:frontend/domain/repositories/user/user.dart';
import 'package:frontend/service_locator.dart';

/// Use case for updating a user.
///
/// This use case encapsulates the logic for updating user information.
/// It uses the [UserRepository] to perform the update operation.
class UpdateUserUsecase implements UseCase<Either<Failure, void>, UpdateUserReq> {
  /// Calls the update user operation with the provided parameters.
  ///
  /// Takes an [UpdateUserReq] as parameters and returns a [Future] that
  /// resolves to an [Either] containing a [Failure] in case of an error,
  /// or [void] if the operation is successful.
  @override
  Future<Either<Failure, void>> call({required UpdateUserReq params}) {
    return sl<UserRepository>().updateUser(params);
  }
}
