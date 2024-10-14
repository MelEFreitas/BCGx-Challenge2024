import 'package:dartz/dartz.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/data/models/user/update_user_req.dart';

abstract class UserRepository {
  Future<Either<Failure, void>> updateUser(UpdateUserReq req);
}