part of 'get_chat_cubit.dart';

sealed class GetChatState extends Equatable {
  const GetChatState();

  @override
  List<Object> get props => [];
}

class GetChatStateInitial extends GetChatState {}

class GetChatStateLoading extends GetChatState {}

class GetChatStateSuccess extends GetChatState {
  const GetChatStateSuccess({required this.chat});

  final ChatEntity chat;

  @override
  List<Object> get props => [chat];
}

class GetChatStateFailure extends GetChatState {
  const GetChatStateFailure({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
