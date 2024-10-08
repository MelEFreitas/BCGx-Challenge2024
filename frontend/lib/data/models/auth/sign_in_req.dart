class SignInReq {
  SignInReq({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'password': password,
    };
  }
}
