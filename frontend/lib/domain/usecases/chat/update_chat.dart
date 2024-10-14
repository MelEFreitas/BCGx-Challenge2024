import 'package:dartz/dartz.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/core/usecase/usecase.dart';
import 'package:frontend/data/models/chat/update_chat_req.dart';
import 'package:frontend/domain/repositories/chat/chat.dart';
import 'package:frontend/service_locator.dart';

class UpdateChatUseCase
    implements UseCase<Either<Failure, void>, UpdateChatReq> {
  @override
  Future<Either<Failure, void>> call({required UpdateChatReq params}) async {
    return sl<ChatRepository>().updateChat(params);
  }
}
