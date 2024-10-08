import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/data/models/auth/sign_up_req.dart';
import 'package:frontend/domain/usecases/auth/sign_up.dart';
import 'package:frontend/presentation/auth/cubits/sign_up/sign_up_state.dart';
import 'package:frontend/service_locator.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpStateInitial());

  Future<void> signUp(String email, String password, String role) async {
    emit(SignUpStateLoading());
    final Either<Failure, void> signUpResult = await sl<SignUpUseCase>()
        .call(params: SignUpReq(email: email, password: password, role: role));
    signUpResult.fold(
        (failure) => emit(SignUpStateFailure(errorMessage: failure.message)),
        (_) => emit(SignUpStateSuccess()));
  }
}
