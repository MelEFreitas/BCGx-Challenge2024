part of 'create_chat_cubit.dart';

sealed class CreateChatState extends Equatable {
  const CreateChatState();

  @override
  List<Object> get props => [];
}

class CreateChatStateInitial extends CreateChatState {}

class CreateChatStateLoading extends CreateChatState {}

class CreateChatStateSuccess extends CreateChatState {
  const CreateChatStateSuccess({required this.chat});

  final ChatEntity chat;

  @override
  List<Object> get props => [chat];
}

class CreateChatStateFailure extends CreateChatState {
  const CreateChatStateFailure({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
