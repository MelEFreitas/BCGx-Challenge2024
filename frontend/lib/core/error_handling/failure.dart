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

class GetAllChatSummariesFailure extends Failure {
  const GetAllChatSummariesFailure({String? message})
      : super(
            message: message ??
                'An unknown exception occurred when fetching all the user\'s chat summaries.');
}

class DeleteChatFailure extends Failure {
  const DeleteChatFailure({String? message})
      : super(
            message: message ??
                'An unknown exception occurred when deleting the chat.');
}

class CreateChatFailure extends Failure {
  const CreateChatFailure({String? message})
      : super(
            message: message ??
                'An unknown exception occured when creating the chat.');
}

class GetChatFailure extends Failure {
  const GetChatFailure({String? message})
      : super(
            message: message ??
                'An unknown exception occured when fetching the chat.');
}

class UpdateChatFailure extends Failure {
  const UpdateChatFailure({String? message})
      : super(
            message: message ??
                'An unknown exception occured when updating the chat.');
}

class UpdateUserFailure extends Failure {
  const UpdateUserFailure({String? message})
      : super(
            message: message ??
                'An unknown exception occured when updating the user.');
}