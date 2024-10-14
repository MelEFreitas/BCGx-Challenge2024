class ApiUrls {
  static const baseUrl = 'http://localhost:8000/';
  static const createUserUrl = '${baseUrl}users';
  static const authenticateUserUrl = '${baseUrl}users/me';
  static const updateUserRoleUrl = '${baseUrl}users/me/role';
  static const createTokenUrl = '${baseUrl}token';
  static const chatUrl = '${baseUrl}chats';
}
