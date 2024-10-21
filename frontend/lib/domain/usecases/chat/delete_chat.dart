import 'package:dartz/dartz.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/core/usecase/usecase.dart';
import 'package:frontend/data/models/chat/delete_chat_req.dart';
import 'package:frontend/domain/repositories/chat/chat.dart';
import 'package:frontend/service_locator.dart';

class DeleteChatUseCase
    implements UseCase<Either<Failure, void>, DeleteChatReq> {
  @override
  Future<Either<Failure, void>> call({required DeleteChatReq params}) async {
    return sl<ChatRepository>().deleteChat(params);
  }
}
