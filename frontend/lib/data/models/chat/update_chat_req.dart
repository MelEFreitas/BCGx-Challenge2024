class UpdateChatReq {
  UpdateChatReq({required this.chatId, required this.question});

  final String chatId;
  final String question;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'question': question};
  }
}
