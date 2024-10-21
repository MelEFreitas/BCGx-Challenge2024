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

/// Implementation of the [AuthRepository] interface.
///
/// This class handles authentication-related operations, such as
/// signing in, signing up, signing out, and retrieving the authenticated user.
class AuthRepositoryImpl extends AuthRepository {
  /// Signs in a user using the provided [SignInReq] request.
  ///
  /// Returns an [Either] containing a [Failure] if an error occurs,
  /// or `void` if the sign-in is successful.
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

  /// Signs out the current user.
  ///
  /// This method returns `void` when the sign-out is successful.
  @override
  Future<void> signOut() async {
    return await sl<AuthLocalService>().signOut();
  }

  /// Signs up a new user using the provided [SignUpReq] request.
  ///
  /// Returns an [Either] containing a [Failure] if an error occurs,
  /// or `void` if the sign-up is successful.
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

  /// Authenticates the user and retrieves their information.
  ///
  /// Returns an [Either] containing a [Failure] if an error occurs,
  /// or a [UserEntity] if the authentication is successful.
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
