import 'package:dartz/dartz.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/data/models/user/update_user_req.dart';

/// Abstract class for user data operations.
///
/// This interface defines the methods that any user repository
/// must implement, specifically for updating user information.
abstract class UserRepository {
  /// Updates the user's information.
  ///
  /// Takes an [UpdateUserReq] as a parameter which contains the
  /// data required to update the user. Returns a [Future] that resolves
  /// to an [Either] containing a [Failure] in case of an error,
  /// or [void] if the operation is successful.
  Future<Either<Failure, void>> updateUser(UpdateUserReq req);
}
