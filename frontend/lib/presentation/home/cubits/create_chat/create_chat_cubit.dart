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
class CreateChatCubit extends Cubit<CreateChatState> {
  /// Constructs the CreateChatCubit and initializes the state to [CreateChatStateInitial].
  CreateChatCubit() : super(CreateChatStateInitial());

  /// Creates a chat with the provided [question] and emits the corresponding states.
  Future<void> createChat(String question) async {
    emit(CreateChatStateLoading());

    final Either<Failure, ChatEntity> result = await sl<CreateChatUseCase>().call(
      params: CreateChatReq(question: question),
    );

    result.fold(
      (failure) => emit(CreateChatStateFailure(errorMessage: failure.message)),
      (chat) => emit(CreateChatStateSuccess(chat: chat)),
    );
  }
}
