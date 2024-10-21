class CustomException implements Exception {
  CustomException({this.message, this.statusCode});

  final String? message;
  final int? statusCode;
}

class SignUpException extends CustomException {
  SignUpException({super.message, super.statusCode});
}

class SignInException extends CustomException {
  SignInException({super.message, super.statusCode});
}

class AuthUserException extends CustomException {
  AuthUserException({super.message, super.statusCode});
}

class GetAllChatSummariesException extends CustomException {
  GetAllChatSummariesException({super.message, super.statusCode});
}

class DeleteChatException extends CustomException {
  DeleteChatException({super.message, super.statusCode});
}

class CreateChatException extends CustomException {
  CreateChatException({super.message, super.statusCode});
}

class GetChatException extends CustomException {
  GetChatException({super.message, super.statusCode});
}

class UpdateChatException extends CustomException {
  UpdateChatException({super.message, super.statusCode});
}

class UpdateUserException extends CustomException {
  UpdateUserException({super.message, super.statusCode});
}
