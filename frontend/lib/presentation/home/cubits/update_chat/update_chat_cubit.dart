import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/data/models/chat/update_chat_req.dart';
import 'package:frontend/domain/usecases/chat/update_chat.dart';
import 'package:frontend/service_locator.dart';

part 'update_chat_state.dart';

class UpdateChatCubit extends Cubit<UpdateChatState> {
  UpdateChatCubit() : super(UpdateChatStateInitial());

  Future<void> updateChat(String chatId, String question) async {
    emit(UpdateChatStateLoading());
    final Either<Failure, void> result = await sl<UpdateChatUseCase>()
        .call(params: UpdateChatReq(chatId: chatId, question: question));
    result.fold(
        (failure) =>
            emit(UpdateChatStateFailure(errorMessage: failure.message)),
        (_) => emit(UpdateChatStateSuccess()));
  }
}
