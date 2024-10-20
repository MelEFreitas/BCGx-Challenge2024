/// A model representing a request to update user information.
///
/// This class encapsulates the data required for updating a user's
/// role in the application.
///
/// Attributes:
/// - [role]: The new role to be assigned to the user.
///
/// The class provides a method to convert the instance to a map,
/// which can be useful for serialization or network requests.
class UpdateUserReq {
  /// Creates an instance of [UpdateUserReq].
  ///
  /// Requires [role] to be provided.
  UpdateUserReq({required this.role});

  /// The new role to be assigned to the user.
  final String role;

  /// Converts the [UpdateUserReq] instance to a map.
  ///
  /// Returns a [Map<String, dynamic>] containing the new role.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{'role': role};
  }
}
