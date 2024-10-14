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

class GetAllChatSummariesException extends CustomException {
  GetAllChatSummariesException({super.message});
}

class DeleteChatException extends CustomException {
  DeleteChatException({super.message});
}

class CreateChatException extends CustomException {
  CreateChatException({super.message});
}

class GetChatException extends CustomException {
  GetChatException({super.message});
}

class UpdateChatException extends CustomException {
  UpdateChatException({super.message});
}

class UpdateUserException extends CustomException {
  UpdateUserException({super.message});
}
