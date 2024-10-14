import 'package:dartz/dartz.dart';
import 'package:frontend/core/error_handling/exception.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/data/models/auth/sign_in_req.dart';
import 'package:frontend/data/models/auth/sign_up_req.dart';
import 'package:frontend/data/sources/auth/auth_api_service.dart';
import 'package:frontend/data/sources/auth/auth_local_service.dart';
import 'package:frontend/domain/entities/user/user.dart';
import 'package:frontend/domain/repositories/auth/auth.dart';
import 'package:frontend/service_locator.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either<Failure, void>> signIn(SignInReq req) async {
    try {
      return Right(await sl<AuthApiService>().signIn(req));
    } on SignInException catch (e) {
      return Left(SignInFailure(message: e.message));
    } catch (_) {
      return const Left(SignInFailure());
    }
  }

  @override
  Future<void> signOut() async {
    return await sl<AuthLocalService>().signOut();
  }

  @override
  Future<Either<Failure, void>> signUp(SignUpReq req) async {
    try {
      return Right(await sl<AuthApiService>().signUp(req));
    } on SignUpException catch (e) {
      return Left(SignUpFailure(message: e.message));
    } catch (_) {
      return const Left(SignUpFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> authUser() async {
    try {
      final user = await sl<AuthApiService>().authUser();
      return Right(user.toEntity());
    } on AuthUserException catch (e) {
      return Left(AuthUserFailure(message: e.message));
    } catch (_) {
      return const Left(AuthUserFailure());
    }
  }
}
