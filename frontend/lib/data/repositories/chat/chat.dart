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

/// Implementation of the [ChatRepository] interface.
///
/// This class manages chat-related operations, such as creating, 
/// deleting, updating, and retrieving chat entities. It communicates
/// with the [ChatApiService] to perform necessary API calls.
class ChatRepositoryImpl implements ChatRepository {
  /// Creates a new chat using the provided [CreateChatReq] request.
  ///
  /// Returns an [Either] containing a [Failure] if an error occurs,
  /// or the created [ChatEntity] if successful.
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

  /// Deletes a chat based on the provided [DeleteChatReq] request.
  ///
  /// Returns an [Either] containing a [Failure] if an error occurs,
  /// or `void` if the deletion is successful.
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

  /// Retrieves all chat summaries.
  ///
  /// Returns an [Either] containing a [Failure] if an error occurs,
  /// or a list of [ChatSummaryEntity] if successful.
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

  /// Retrieves a chat based on the provided [GetChatReq] request.
  ///
  /// Returns an [Either] containing a [Failure] if an error occurs,
  /// or the corresponding [ChatEntity] if successful.
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

  /// Updates an existing chat using the provided [UpdateChatReq] request.
  ///
  /// Returns an [Either] containing a [Failure] if an error occurs,
  /// or `void` if the update is successful.
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
