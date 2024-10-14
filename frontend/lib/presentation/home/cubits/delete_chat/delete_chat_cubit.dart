import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/data/models/chat/delete_chat_req.dart';
import 'package:frontend/domain/usecases/chat/delete_chat.dart';
import 'package:frontend/service_locator.dart';

part 'delete_chat_state.dart';

class DeleteChatCubit extends Cubit<DeleteChatState> {
  DeleteChatCubit() : super(DeleteChatStateInitital());

  Future<void> deleteChat(int chatId) async {
    emit(DeleteChatStateLoading());
    final Either<Failure, void> result = await sl<DeleteChatUseCase>()
        .call(params: DeleteChatReq(chatId: chatId));
    result.fold(
        (failure) =>
            emit(DeleteChatStateFailure(errorMessage: failure.message)),
        (_) => emit(DeleteChatStateSuccess()));
  }
}
