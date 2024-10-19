class ApiUrls {
  static const baseUrl = 'http://localhost:8000/';
  static const createUserUrl = '${baseUrl}users';
  static const authenticateUserUrl = '${baseUrl}users/me';
  static const updateUserRoleUrl = '${baseUrl}users/me/role';
  static const createTokensUrl = '${baseUrl}token';
  static const refreshAccessTokenUrl = '${baseUrl}token/refresh';
  static const chatUrl = '${baseUrl}chats';
}

class TokenKeys {
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
}
