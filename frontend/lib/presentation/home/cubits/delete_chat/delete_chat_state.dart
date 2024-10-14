part of 'delete_chat_cubit.dart';

sealed class DeleteChatState extends Equatable {
  const DeleteChatState();

  @override
  List<Object> get props => [];
}

class DeleteChatStateInitital extends DeleteChatState {}

class DeleteChatStateLoading extends DeleteChatState {}

class DeleteChatStateSuccess extends DeleteChatState {}

class DeleteChatStateFailure extends DeleteChatState {
  const DeleteChatStateFailure({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
