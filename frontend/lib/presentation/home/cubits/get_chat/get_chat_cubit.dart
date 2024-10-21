import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/data/models/chat/get_chat_req.dart';
import 'package:frontend/domain/entities/chat/chat.dart';
import 'package:frontend/domain/usecases/chat/get_chat.dart';
import 'package:frontend/service_locator.dart';

part 'get_chat_state.dart';

/// A Cubit for managing the state of fetching a single chat.
class GetChatCubit extends Cubit<GetChatState> {
  /// Constructs the GetChatCubit and initializes the state to [GetChatStateInitial].
  GetChatCubit() : super(GetChatStateInitial());

  /// Fetches the chat based on the provided [chatId] and emits the corresponding states.
  Future<void> getChat(String chatId) async {
    final Either<Failure, ChatEntity> result =
        await sl<GetChatUseCase>().call(params: GetChatReq(chatId: chatId));

    result.fold(
      (failure) => emit(GetChatStateFailure(errorMessage: failure.message)),
      (chat) => emit(GetChatStateSuccess(chat: chat)),
    );
  }

  /// Resets the chat state to its initial state.
  void resetChat() {
    emit(GetChatStateInitial());
  }
}
