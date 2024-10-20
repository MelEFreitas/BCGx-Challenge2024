import 'package:dartz/dartz.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/data/models/chat/create_chat_req.dart';
import 'package:frontend/data/models/chat/delete_chat_req.dart';
import 'package:frontend/data/models/chat/get_chat_req.dart';
import 'package:frontend/data/models/chat/update_chat_req.dart';
import 'package:frontend/domain/entities/chat/chat.dart';
import 'package:frontend/domain/entities/chat/chat_summary.dart';

/// Abstract class for chat data operations.
///
/// This interface defines the methods that any chat repository
/// must implement, specifically for managing chat data and operations.
abstract class ChatRepository {
  /// Retrieves all chat summaries.
  ///
  /// Returns a [Future] that resolves to an [Either] containing a 
  /// [Failure] in case of an error, or a list of [ChatSummaryEntity] 
  /// objects if the operation is successful.
  Future<Either<Failure, List<ChatSummaryEntity>>> getAllChatSummaries();

  /// Retrieves a specific chat by its ID.
  ///
  /// Takes a [GetChatReq] as a parameter which contains the
  /// ID of the chat to retrieve. Returns a [Future] that resolves 
  /// to an [Either] containing a [Failure] in case of an error,
  /// or a [ChatEntity] if the operation is successful.
  Future<Either<Failure, ChatEntity>> getChat(GetChatReq req);

  /// Creates a new chat.
  ///
  /// Takes a [CreateChatReq] as a parameter which contains the
  /// data required to create a new chat. Returns a [Future] that resolves 
  /// to an [Either] containing a [Failure] in case of an error,
  /// or a [ChatEntity] if the operation is successful.
  Future<Either<Failure, ChatEntity>> createChat(CreateChatReq req);

  /// Deletes a specific chat by its ID.
  ///
  /// Takes a [DeleteChatReq] as a parameter which contains the
  /// ID of the chat to delete. Returns a [Future] that resolves 
  /// to an [Either] containing a [Failure] in case of an error,
  /// or [void] if the operation is successful.
  Future<Either<Failure, void>> deleteChat(DeleteChatReq req);

  /// Updates an existing chat.
  ///
  /// Takes an [UpdateChatReq] as a parameter which contains the
  /// data required to update the chat. Returns a [Future] that resolves 
  /// to an [Either] containing a [Failure] in case of an error,
  /// or [void] if the operation is successful.
  Future<Either<Failure, void>> updateChat(UpdateChatReq req);
}
