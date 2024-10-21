import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/data/models/chat/create_chat_req.dart';
import 'package:frontend/domain/entities/chat/chat.dart';
import 'package:frontend/domain/usecases/chat/create_chat.dart';
import 'package:frontend/service_locator.dart';

part 'create_chat_state.dart';

/// A Cubit for managing the state of creating a chat.
///
/// This Cubit handles the process of creating a chat by invoking the 
/// [CreateChatUseCase] and emitting states based on the result of the 
/// creation attempt.
class CreateChatCubit extends Cubit<CreateChatState> {
  /// Constructs the CreateChatCubit and initializes the state to 
  /// [CreateChatStateInitial].
  CreateChatCubit() : super(CreateChatStateInitial());

  /// Creates a chat with the provided [question] and emits the 
  /// corresponding states.
  ///
  /// This method emits a loading state while the chat creation process 
  /// is ongoing. If the chat creation is successful, it emits a success 
  /// state containing the created chat entity; otherwise, it emits a 
  /// failure state with an error message.
  ///
  /// [question] The question to be included in the chat.
  Future<void> createChat(String question) async {
    emit(CreateChatStateLoading()); // Emit loading state to indicate the process has started.

    // Call the CreateChatUseCase with the provided question.
    final Either<Failure, ChatEntity> result = await sl<CreateChatUseCase>().call(
      params: CreateChatReq(question: question),
    );

    // Handle the result of the chat creation attempt.
    result.fold(
      (failure) => emit(CreateChatStateFailure(errorMessage: failure.message)), // Emit failure state on error.
      (chat) => emit(CreateChatStateSuccess(chat: chat)), // Emit success state with the created chat.
    );
  }
}
