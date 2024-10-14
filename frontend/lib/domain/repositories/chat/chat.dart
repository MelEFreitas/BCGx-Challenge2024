import 'package:dartz/dartz.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/data/models/chat/create_chat_req.dart';
import 'package:frontend/data/models/chat/delete_chat_req.dart';
import 'package:frontend/data/models/chat/get_chat_req.dart';
import 'package:frontend/data/models/chat/update_chat_req.dart';
import 'package:frontend/domain/entities/chat/chat.dart';
import 'package:frontend/domain/entities/chat/chat_summary.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ChatSummaryEntity>>> getAllChatSummaries();
  Future<Either<Failure, ChatEntity>> getChat(GetChatReq req);
  Future<Either<Failure, ChatEntity>> createChat(CreateChatReq req);
  Future<Either<Failure, void>> deleteChat(DeleteChatReq req);
  Future<Either<Failure, void>> updateChat(UpdateChatReq req);
}
