import 'package:frontend/domain/entities/question_answer/question_answer.dart';

class ChatEntity {
  ChatEntity(
      {required this.id, required this.title, required this.conversation});

  final int id;
  final String title;
  final List<QuestionAnswerEntity> conversation;
}
