part of 'get_chat_summaries_cubit.dart';

sealed class GetChatSummariesState extends Equatable {
  const GetChatSummariesState();

  @override
  List<Object> get props => [];
}

class GetChatSummariesStateInitial extends GetChatSummariesState {}

class GetChatSummariesStateLoading extends GetChatSummariesState {}

class GetChatSummariesStateSuccess extends GetChatSummariesState {
  const GetChatSummariesStateSuccess({required this.chatSummaries});

  final List<ChatSummaryEntity> chatSummaries;

  @override
  List<Object> get props => [chatSummaries];
}

class GetChatSummariesStateFailure extends GetChatSummariesState {
  const GetChatSummariesStateFailure({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
