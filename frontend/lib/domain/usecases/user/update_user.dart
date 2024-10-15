import 'package:dartz/dartz.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/core/usecase/usecase.dart';
import 'package:frontend/data/models/user/update_user_req.dart';
import 'package:frontend/domain/repositories/user/user.dart';
import 'package:frontend/service_locator.dart';

class UpdateUserUsecase
    implements UseCase<Either<Failure, void>, UpdateUserReq> {
  @override
  Future<Either<Failure, void>> call({required UpdateUserReq params}) {
    return sl<UserRepository>().updateUser(params);
  }
}
