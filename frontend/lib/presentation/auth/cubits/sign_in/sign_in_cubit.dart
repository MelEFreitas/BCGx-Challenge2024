import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/data/models/auth/sign_in_req.dart';
import 'package:frontend/domain/usecases/auth/sign_in.dart';
import 'package:frontend/presentation/auth/cubits/sign_in/sign_in_state.dart';
import 'package:frontend/service_locator.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInStateInitial());

  Future<void> signIn(String email, String password) async {
    emit(SignInStateLoading());
    final Either<Failure, String> signInResult = await sl<SignInUseCase>()
        .call(params: SignInReq(username: email, password: password));
    signInResult.fold(
        (failure) => emit(SignInStateFailure(errorMessage: failure.message)),
        (token) => emit(SignInStateSuccess(token: token)));
  }
}
