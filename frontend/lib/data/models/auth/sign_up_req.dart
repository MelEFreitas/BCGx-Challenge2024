/// A model representing a sign-up request.
///
/// This class encapsulates the data required for user registration,
/// including the user's email, password, and role.
///
/// Attributes:
/// - [email]: The email address of the user attempting to sign up.
/// - [password]: The password for the new account.
/// - [role]: The role assigned to the user during sign-up.
///
/// The class provides a method to convert the instance to a map,
/// which is useful for serialization or network requests.
class SignUpReq {
  /// Creates an instance of [SignUpReq].
  ///
  /// Requires [email], [password], and [role] to be provided.
  SignUpReq({
    required this.email,
    required this.password,
    required this.role,
  });

  /// The email address of the user attempting to sign up.
  final String email;

  /// The password for the new account.
  final String password;

  /// The role assigned to the user during sign-up.
  final String role;

  /// Converts the [SignUpReq] instance to a map.
  ///
  /// Returns a [Map<String, dynamic>] containing the email, password,
  /// and role.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': password,
      'role': role,
    };
  }
}
