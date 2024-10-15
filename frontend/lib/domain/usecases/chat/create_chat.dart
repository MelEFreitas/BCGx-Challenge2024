import 'package:dartz/dartz.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/core/usecase/usecase.dart';
import 'package:frontend/data/models/chat/create_chat_req.dart';
import 'package:frontend/domain/entities/chat/chat.dart';
import 'package:frontend/domain/repositories/chat/chat.dart';
import 'package:frontend/service_locator.dart';

class CreateChatUseCase
    implements UseCase<Either<Failure, ChatEntity>, CreateChatReq> {
  @override
  Future<Either<Failure, ChatEntity>> call(
      {required CreateChatReq params}) async {
    return sl<ChatRepository>().createChat(params);
  }
}
