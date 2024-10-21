import 'package:dartz/dartz.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/core/usecase/usecase.dart';
import 'package:frontend/data/models/chat/get_chat_req.dart';
import 'package:frontend/domain/entities/chat/chat.dart';
import 'package:frontend/domain/repositories/chat/chat.dart';
import 'package:frontend/service_locator.dart';

class GetChatUseCase
    implements UseCase<Either<Failure, ChatEntity>, GetChatReq> {
  @override
  Future<Either<Failure, ChatEntity>> call({required GetChatReq params}) async {
    return sl<ChatRepository>().getChat(params);
  }
}
