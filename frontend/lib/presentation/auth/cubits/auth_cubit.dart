import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/entities/user/user.dart';
import 'package:frontend/domain/repositories/auth/auth.dart';

import '../../../../service_locator.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthStateUnauthenticated()) {}
}