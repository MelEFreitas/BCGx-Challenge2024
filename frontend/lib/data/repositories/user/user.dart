import 'package:dartz/dartz.dart';
import 'package:frontend/core/error_handling/exception.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/data/models/user/update_user_req.dart';
import 'package:frontend/data/sources/user/user_api_service.dart';
import 'package:frontend/domain/repositories/user/user.dart';
import 'package:frontend/service_locator.dart';

/// Implementation of the [UserRepository] interface.
///
/// This class handles the logic for user-related operations,
/// specifically updating user information. It interacts with
/// the [UserApiService] to perform API calls and manage
/// user data.
class UserRepositoryImpl implements UserRepository {
  /// Updates the user with the provided [UpdateUserReq] request.
  ///
  /// This method sends the update request to the user API service
  /// and returns an [Either] containing a [Failure] in case of an
  /// error, or `void` if the operation is successful.
  @override
  Future<Either<Failure, void>> updateUser(UpdateUserReq req) async {
    try {
      return Right(await sl<UserApiService>().updateUser(req));
    } on UpdateUserException catch (e) {
      return Left(UpdateChatFailure(message: e.message));
    } catch (_) {
      return const Left(UpdateChatFailure());
    }
  }
}
