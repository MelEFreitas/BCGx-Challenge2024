import 'package:dartz/dartz.dart';
import 'package:frontend/core/error_handling/exception.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/data/models/user/update_user_req.dart';
import 'package:frontend/data/sources/user/user_api_service.dart';
import 'package:frontend/domain/repositories/user/user.dart';
import 'package:frontend/service_locator.dart';

class UserRepositoryImpl implements UserRepository {
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
