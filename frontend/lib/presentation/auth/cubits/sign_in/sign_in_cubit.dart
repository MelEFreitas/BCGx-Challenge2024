import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/data/models/auth/sign_in_req.dart';
import 'package:frontend/domain/usecases/auth/sign_in.dart';
import 'package:frontend/service_locator.dart';

part 'sign_in_state.dart';

/// A Cubit for managing sign-in state.
///
/// This Cubit handles user sign-in by calling the SignInUseCase and emits
/// states based on the result of the sign-in attempt.
class SignInCubit extends Cubit<SignInState> {
  /// Initializes the SignInCubit with an initial state.
  SignInCubit() : super(SignInStateInitial());

  /// Attempts to sign in the user with the provided email and password.
  ///
  /// This method emits a loading state while the sign-in process is ongoing.
  /// If the sign-in is successful, it emits a success state; otherwise,
  /// it emits a failure state with an error message.
  ///
  /// [email] The email address of the user trying to sign in.
  /// [password] The password of the user trying to sign in.
  Future<void> signIn(String email, String password) async {
    emit(SignInStateLoading()); // Emit loading state to indicate sign-in process has started.

    // Call the SignInUseCase with the provided email and password.
    final Either<Failure, void> signInResult = await sl<SignInUseCase>()
        .call(params: SignInReq(username: email, password: password));

    // Handle the result of the sign-in attempt.
    signInResult.fold(
      (failure) => emit(SignInStateFailure(errorMessage: failure.message)), // Emit failure state on error.
      (_) => emit(SignInStateSuccess()), // Emit success state on successful sign-in.
    );
  }
}
