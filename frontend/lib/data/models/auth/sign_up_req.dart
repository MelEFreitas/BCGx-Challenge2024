class SignUpReq {
  SignUpReq({
    required this.email,
    required this.password,
    required this.role,
  });

  final String email;
  final String password;
  final String role;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': password,
      'role': role,
    };
  }
}
