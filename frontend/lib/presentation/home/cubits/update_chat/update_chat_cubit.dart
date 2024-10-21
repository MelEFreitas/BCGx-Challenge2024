import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/data/models/chat/update_chat_req.dart';
import 'package:frontend/domain/usecases/chat/update_chat.dart';
import 'package:frontend/service_locator.dart';

part 'update_chat_state.dart';

/// A Cubit for managing the state of chat updates.
class UpdateChatCubit extends Cubit<UpdateChatState> {
  /// Constructs the UpdateChatCubit with an initial state of [UpdateChatStateInitial].
  UpdateChatCubit() : super(UpdateChatStateInitial());

  /// Updates the chat with a new question.
  ///
  /// Emits a loading state while the update is in progress.
  /// If the update is successful, it emits [UpdateChatStateSuccess].
  /// If it fails, it emits [UpdateChatStateFailure] with the error message.
  ///
  /// [chatId] is the unique identifier of the chat to be updated.
  /// [question] is the new question content to be assigned to the chat.
  Future<void> updateChat(String chatId, String question) async {
    emit(UpdateChatStateLoading());
    
    final Either<Failure, void> result = await sl<UpdateChatUseCase>()
        .call(params: UpdateChatReq(chatId: chatId, question: question));
    
    result.fold(
      (failure) => emit(UpdateChatStateFailure(errorMessage: failure.message)),
      (_) => emit(UpdateChatStateSuccess()),
    );
  }
}
