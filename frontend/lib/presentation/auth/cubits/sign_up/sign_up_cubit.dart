import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/data/models/auth/sign_up_req.dart';
import 'package:frontend/domain/usecases/auth/sign_up.dart';
import 'package:frontend/service_locator.dart';

part 'sign_up_state.dart';

/// A Cubit for managing sign-up state.
///
/// This Cubit handles user sign-up by calling the SignUpUseCase and emits
/// states based on the result of the sign-up attempt.
class SignUpCubit extends Cubit<SignUpState> {
  /// Initializes the SignUpCubit with an initial state.
  SignUpCubit() : super(SignUpStateInitial());

  /// Attempts to sign up the user with the provided email, password, and role.
  ///
  /// This method emits a loading state while the sign-up process is ongoing.
  /// If the sign-up is successful, it emits a success state; otherwise,
  /// it emits a failure state with an error message.
  ///
  /// [email] The email address of the user trying to sign up.
  /// [password] The password of the user trying to sign up.
  /// [role] The role assigned to the user during sign-up.
  Future<void> signUp(String email, String password, String role) async {
    emit(SignUpStateLoading()); // Emit loading state to indicate sign-up process has started.

    // Call the SignUpUseCase with the provided email, password, and role.
    final Either<Failure, void> signUpResult = await sl<SignUpUseCase>()
        .call(params: SignUpReq(email: email, password: password, role: role));

    // Handle the result of the sign-up attempt.
    signUpResult.fold(
      (failure) => emit(SignUpStateFailure(errorMessage: failure.message)), // Emit failure state on error.
      (_) => emit(SignUpStateSuccess()), // Emit success state on successful sign-up.
    );
  }
}
