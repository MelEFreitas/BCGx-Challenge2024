/// A model representing a sign-in request.
///
/// This class is used to encapsulate the data required for signing in,
/// including the user's credentials.
///
/// Attributes:
/// - [username]: The username of the user attempting to sign in.
/// - [password]: The password associated with the username.
///
/// The class provides a method to convert the instance to a map, which
/// can be useful for serialization or network requests.
class SignInReq {
  /// Creates an instance of [SignInReq].
  ///
  /// Requires [username] and [password] to be provided.
  SignInReq({
    required this.username,
    required this.password,
  });

  /// The username of the user attempting to sign in.
  final String username;

  /// The password associated with the username.
  final String password;

  /// Converts the [SignInReq] instance to a map.
  ///
  /// Returns a [Map<String, dynamic>] containing the username and password.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'password': password,
    };
  }
}
