import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/domain/entities/chat/chat_summary.dart';
import 'package:frontend/domain/usecases/chat/get_all_chat_summaries.dart';
import 'package:frontend/service_locator.dart';

part 'get_chat_summaries_state.dart';

/// A Cubit for managing the state of chat summaries.
class GetChatSummariesCubit extends Cubit<GetChatSummariesState> {
  /// Constructs the GetChatSummariesCubit and immediately fetches all chat summaries.
  GetChatSummariesCubit() : super(GetChatSummariesStateInitial()) {
    getAllChatSummaries();
  }

  /// Fetches all chat summaries and emits the corresponding states.
  Future<void> getAllChatSummaries() async {
    emit(GetChatSummariesStateLoading());
    final Either<Failure, List<ChatSummaryEntity>> result =
        await sl<GetAllChatSummariesUseCase>().call();
    
    result.fold(
      (failure) => emit(GetChatSummariesStateFailure(errorMessage: failure.message)),
      (chatSummaries) => emit(GetChatSummariesStateSuccess(chatSummaries: chatSummaries)),
    );
  }
}
