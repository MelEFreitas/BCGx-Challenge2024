import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/data/models/auth/auth_user_req.dart';
import 'package:frontend/domain/entities/user/user.dart';
import 'package:frontend/domain/usecases/auth/auth_user.dart';
import 'package:frontend/service_locator.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthStateUnauthenticated());

  Future<void> authenticateUser(String token) async {
    final Either<Failure, UserEntity> authResult =
        await sl<AuthUserUseCase>().call(params: AuthUserReq(token: token));
    authResult.fold((failure) => emit(const AuthStateUnauthenticated()),
        (user) => emit(AuthStateAuthenticated(user: user)));
  }
}
