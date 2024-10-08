class CustomException implements Exception {
  CustomException({this.message});

  final String? message;
}

class SignUpException extends CustomException {
  SignUpException({super.message});
}

class SignInException extends CustomException {
  SignInException({super.message});
}

class AuthUserException extends CustomException {
  AuthUserException({super.message});
}
