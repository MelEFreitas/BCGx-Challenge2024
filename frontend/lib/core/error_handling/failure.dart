abstract class Failure {
  final String message;

  const Failure({required this.message});
}

class SignInFailure extends Failure {
  const SignInFailure({String? message})
      : super(
            message:
                message ?? 'An unknown exception occurred when signing in.');
}

class SignUpFailure extends Failure {
  const SignUpFailure({String? message})
      : super(
            message:
                message ?? 'An unknown exception occurred when signing up.');
}

class AuthUserFailure extends Failure {
  const AuthUserFailure({String? message})
      : super(
            message: message ??
                'An unknown exception occurred when authenticating the user.');
}
