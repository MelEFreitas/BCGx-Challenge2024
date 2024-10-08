part of 'auth_cubit.dart';

enum AuthStatus { authenticated, unauthenticated }

abstract class AuthState extends Equatable {
  const AuthState({required this.status});

  final AuthStatus status;

  @override
  List<Object> get props => [status];
}

class AuthStateAuthenticated extends AuthState {
  const AuthStateAuthenticated({required this.user})
      : super(status: AuthStatus.authenticated);

  final UserEntity user;

  @override
  List<Object> get props => [status, user];
}

class AuthStateUnauthenticated extends AuthState {
  const AuthStateUnauthenticated() : super(status: AuthStatus.unauthenticated);
}
