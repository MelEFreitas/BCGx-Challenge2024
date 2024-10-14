import 'package:dartz/dartz.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/core/usecase/usecase.dart';
import 'package:frontend/domain/entities/chat/chat_summary.dart';
import 'package:frontend/domain/repositories/chat/chat.dart';
import 'package:frontend/service_locator.dart';

class GetAllChatSummariesUseCase
    implements UseCase<Either<Failure, List<ChatSummaryEntity>>, void> {
  @override
  Future<Either<Failure, List<ChatSummaryEntity>>> call({void params}) async {
    return sl<ChatRepository>().getAllChatSummaries();
  }
}
