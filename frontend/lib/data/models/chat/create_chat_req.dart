class CreateChatReq {
  CreateChatReq({required this.question});

  final String question;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'question': question};
  }
}
