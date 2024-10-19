import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/data/models/chat/get_chat_req.dart';
import 'package:frontend/domain/entities/chat/chat.dart';
import 'package:frontend/domain/usecases/chat/get_chat.dart';
import 'package:frontend/service_locator.dart';

part 'get_chat_state.dart';

class GetChatCubit extends Cubit<GetChatState> {
  GetChatCubit() : super(GetChatStateInitial());

  Future<void> getChat(String chatId) async {
    emit(GetChatStateLoading());
    final Either<Failure, ChatEntity> result =
        await sl<GetChatUseCase>().call(params: GetChatReq(chatId: chatId));
    result.fold(
        (failure) => emit(GetChatStateFailure(errorMessage: failure.message)),
        (chat) => emit(GetChatStateSuccess(chat: chat)));
  }

  void resetChat() {
    emit(GetChatStateInitial());
  }
}
