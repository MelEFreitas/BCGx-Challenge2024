class UpdateUserReq {
  UpdateUserReq({required this.role});

  final String role;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'role': role};
  }
}
