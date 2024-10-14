import 'package:dartz/dartz.dart';
import 'package:frontend/core/error_handling/exception.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/data/models/chat/create_chat_req.dart';
import 'package:frontend/data/models/chat/delete_chat_req.dart';
import 'package:frontend/data/models/chat/get_chat_req.dart';
import 'package:frontend/data/models/chat/update_chat_req.dart';
import 'package:frontend/data/sources/chat/chat_api_service.dart';
import 'package:frontend/domain/entities/chat/chat.dart';
import 'package:frontend/domain/entities/chat/chat_summary.dart';
import 'package:frontend/domain/repositories/chat/chat.dart';
import 'package:frontend/service_locator.dart';

class ChatRepositoryImpl implements ChatRepository {
  @override
  Future<Either<Failure, ChatEntity>> createChat(CreateChatReq req) async {
    try {
      final chat = await sl<ChatApiService>().createChat(req);
      return Right(chat.toEntity());
    } on CreateChatException catch (e) {
      return Left(CreateChatFailure(message: e.message));
    } catch (_) {
      return const Left(CreateChatFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteChat(DeleteChatReq req) async {
    try {
      return Right(await sl<ChatApiService>().deleteChat(req));
    } on DeleteChatException catch (e) {
      return Left(DeleteChatFailure(message: e.message));
    } catch (_) {
      return const Left(DeleteChatFailure());
    }
  }

  @override
  Future<Either<Failure, List<ChatSummaryEntity>>> getAllChatSummaries() async {
    try {
      final chatSummaries = await sl<ChatApiService>().getAllChatSummaries();
      List<ChatSummaryEntity> chatEntities =
          chatSummaries.map((chat) => chat.toEntity()).toList();
      return Right(chatEntities);
    } on GetAllChatSummariesException catch (e) {
      return Left(GetAllChatSummariesFailure(message: e.message));
    } catch (_) {
      return const Left(GetAllChatSummariesFailure());
    }
  }

  @override
  Future<Either<Failure, ChatEntity>> getChat(GetChatReq req) async {
    try {
      final chat = await sl<ChatApiService>().getChat(req);
      return Right(chat.toEntity());
    } on GetChatException catch (e) {
      return Left(GetChatFailure(message: e.message));
    } catch (_) {
      return const Left(GetChatFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateChat(UpdateChatReq req) async {
    try {
      return Right(await sl<ChatApiService>().updateChat(req));
    } on UpdateChatException catch (e) {
      return Left(UpdateChatFailure(message: e.message));
    } catch (_) {
      return const Left(UpdateChatFailure());
    }
  }
}
