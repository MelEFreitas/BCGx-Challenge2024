part of 'update_chat_cubit.dart';

sealed class UpdateChatState extends Equatable {
  const UpdateChatState();

  @override
  List<Object> get props => [];
}

class UpdateChatStateInitial extends UpdateChatState {}

class UpdateChatStateLoading extends UpdateChatState {}

class UpdateChatStateSuccess extends UpdateChatState {}

class UpdateChatStateFailure extends UpdateChatState {
  const UpdateChatStateFailure({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
