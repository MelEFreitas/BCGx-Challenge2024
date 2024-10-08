class AuthUserReq {
  AuthUserReq({required this.token});

  final String token;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'token': token};
  }
}
