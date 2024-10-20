import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/data/models/chat/delete_chat_req.dart';
import 'package:frontend/domain/usecases/chat/delete_chat.dart';
import 'package:frontend/service_locator.dart';

part 'delete_chat_state.dart';

/// A Cubit for managing the state of deleting a chat.
///
/// This Cubit handles the process of deleting a chat by invoking the 
/// [DeleteChatUseCase] and emitting states based on the result of the 
/// deletion attempt.
class DeleteChatCubit extends Cubit<DeleteChatState> {
  /// Constructs the DeleteChatCubit and initializes the state to 
  /// [DeleteChatStateInitial].
  DeleteChatCubit() : super(DeleteChatStateInitial()); // Fixed typo in state name.

  /// Deletes a chat with the provided [chatId] and emits the 
  /// corresponding states.
  ///
  /// This method emits a loading state while the chat deletion process 
  /// is ongoing. If the deletion is successful, it emits a success 
  /// state; otherwise, it emits a failure state with an error message.
  ///
  /// [chatId] The identifier of the chat to be deleted.
  Future<void> deleteChat(String chatId) async {
    emit(DeleteChatStateLoading()); // Emit loading state to indicate the process has started.

    // Call the DeleteChatUseCase with the provided chatId.
    final Either<Failure, void> result = await sl<DeleteChatUseCase>().call(
      params: DeleteChatReq(chatId: chatId),
    );

    // Handle the result of the chat deletion attempt.
    result.fold(
      (failure) => emit(DeleteChatStateFailure(errorMessage: failure.message)), // Emit failure state on error.
      (_) => emit(DeleteChatStateSuccess()), // Emit success state if deletion is successful.
    );
  }
}
