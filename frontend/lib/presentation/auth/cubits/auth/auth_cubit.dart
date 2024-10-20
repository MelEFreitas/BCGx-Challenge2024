import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/data/sources/auth/auth_local_service.dart';
import 'package:frontend/domain/entities/user/user.dart';
import 'package:frontend/domain/usecases/auth/auth_user.dart';
import 'package:frontend/service_locator.dart';

part 'auth_state.dart';

/// A Cubit for managing authentication state.
///
/// This Cubit handles user authentication by calling the AuthUserUseCase
/// and emits states based on the authentication result. It also provides
/// functionality for signing out users.
class AuthCubit extends Cubit<AuthState> {
  // Initializes the AuthCubit with an unauthenticated state and 
  // immediately attempts to authenticate the user.
  AuthCubit() : super(const AuthStateUnauthenticated()) {
    authenticateUser(); // Attempt to authenticate the user on initialization.
  }

  /// Authenticates the user by calling the AuthUserUseCase.
  ///
  /// It emits an [AuthStateAuthenticated] state if authentication succeeds,
  /// or an [AuthStateUnauthenticated] state if it fails.
  Future<void> authenticateUser() async {
    final Either<Failure, UserEntity> authResult =
        await sl<AuthUserUseCase>().call(); // Call the use case to authenticate.
        
    // Handle the result of the authentication.
    authResult.fold(
      (failure) => emit(const AuthStateUnauthenticated()), // Emit unauthenticated state on failure.
      (user) => emit(AuthStateAuthenticated(user: user)), // Emit authenticated state on success.
    );
  }

  /// Signs the user out and re-authenticates the user.
  ///
  /// It first calls the signOut method from the AuthLocalService and then
  /// attempts to re-authenticate the user.
  Future<void> signOut() async {
    await sl<AuthLocalService>().signOut(); // Perform sign-out.
    await authenticateUser(); // Re-authenticate after signing out.
  }
}
