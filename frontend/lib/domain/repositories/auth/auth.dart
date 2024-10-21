import 'package:dartz/dartz.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/data/models/auth/sign_in_req.dart';
import 'package:frontend/data/models/auth/sign_up_req.dart';
import 'package:frontend/domain/entities/user/user.dart';

/// Abstract class for authentication operations.
///
/// This interface defines the methods that any authentication repository
/// must implement, specifically for managing user authentication and
/// session management.
abstract class AuthRepository {
  /// Signs out the current user.
  ///
  /// This method is responsible for signing out the current user.
  /// It does not return any value.
  Future<void> signOut();

  /// Signs in a user.
  ///
  /// Takes a [SignInReq] as a parameter which contains the
  /// credentials required for signing in. Returns a [Future] that resolves 
  /// to an [Either] containing a [Failure] in case of an error,
  /// or [void] if the operation is successful.
  Future<Either<Failure, void>> signIn(SignInReq req);

  /// Signs up a new user.
  ///
  /// Takes a [SignUpReq] as a parameter which contains the
  /// information required to create a new user account. Returns a [Future] that resolves 
  /// to an [Either] containing a [Failure] in case of an error,
  /// or [void] if the operation is successful.
  Future<Either<Failure, void>> signUp(SignUpReq req);

  /// Authenticates the current user.
  ///
  /// Returns a [Future] that resolves to an [Either] containing a 
  /// [Failure] in case of an error, or a [UserEntity] if the operation
  /// is successful and the user is authenticated.
  Future<Either<Failure, UserEntity>> authUser();
}
