import 'package:frontend/core/infrastructure/shared_preferences_service.dart';
import 'package:frontend/core/network/dio_client.dart';
import 'package:frontend/data/repositories/auth/auth.dart';
import 'package:frontend/data/repositories/chat/chat.dart';
import 'package:frontend/data/repositories/user/user.dart';
import 'package:frontend/data/sources/auth/auth_api_service.dart';
import 'package:frontend/data/sources/auth/auth_local_service.dart';
import 'package:frontend/data/sources/chat/chat_api_service.dart';
import 'package:frontend/data/sources/user/user_api_service.dart';
import 'package:frontend/domain/repositories/auth/auth.dart';
import 'package:frontend/domain/repositories/chat/chat.dart';
import 'package:frontend/domain/repositories/user/user.dart';
import 'package:frontend/domain/usecases/auth/auth_user.dart';
import 'package:frontend/domain/usecases/auth/sign_in.dart';
import 'package:frontend/domain/usecases/auth/sign_up.dart';
import 'package:frontend/domain/usecases/chat/create_chat.dart';
import 'package:frontend/domain/usecases/chat/delete_chat.dart';
import 'package:frontend/domain/usecases/chat/get_all_chat_summaries.dart';
import 'package:frontend/domain/usecases/chat/get_chat.dart';
import 'package:frontend/domain/usecases/chat/update_chat.dart';
import 'package:frontend/domain/usecases/user/update_user.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

/// Initializes and registers the application dependencies using the GetIt package.
///
/// This function is responsible for setting up the dependency injection
/// container and registering various services, repositories, and use cases
/// required for the application to function properly.
///
/// The following components are registered:
/// 
/// - **HTTP Client**: 
///   - [DioClient]: A singleton instance of the Dio HTTP client for making network requests.
/// 
/// - **Services**:
///   - [SharedPreferencesService]: A service for managing local storage preferences.
///   - [AuthApiService]: A service for handling authentication-related API calls.
///   - [AuthLocalService]: A service for handling local authentication data.
///   - [ChatApiService]: A service for managing chat-related API calls.
///   - [UserApiService]: A service for managing user-related API calls.
/// 
/// - **Repositories**:
///   - [AuthRepository]: A repository for managing authentication data and actions.
///   - [ChatRepository]: A repository for managing chat data and actions.
///   - [UserRepository]: A repository for managing user data and actions.
/// 
/// - **Use Cases**:
///   - [SignInUseCase]: Use case for handling user sign-in operations.
///   - [SignUpUseCase]: Use case for handling user sign-up operations.
///   - [AuthUserUseCase]: Use case for managing user authentication state.
///   - [CreateChatUseCase]: Use case for creating new chat instances.
///   - [DeleteChatUseCase]: Use case for deleting existing chats.
///   - [UpdateChatUseCase]: Use case for updating chat information.
///   - [GetChatUseCase]: Use case for retrieving a specific chat.
///   - [GetAllChatSummariesUseCase]: Use case for retrieving summaries of all chats.
///   - [UpdateUserUsecase]: Use case for updating user information.
Future<void> initializeDependencies() async {
  // HTTP Client
  sl.registerSingleton<DioClient>(DioClient());

  // Services
  sl.registerSingleton<SharedPreferencesService>(SharedPreferencesService());
  sl.registerSingleton<AuthApiService>(AuthApiServiceImpl());
  sl.registerSingleton<AuthLocalService>(AuthLocalServiceImpl());
  sl.registerSingleton<ChatApiService>(ChatApiServiceImpl());
  sl.registerSingleton<UserApiService>(UserApiServiceImpl());

  // Repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<ChatRepository>(ChatRepositoryImpl());
  sl.registerSingleton<UserRepository>(UserRepositoryImpl());

  // Usecases
  sl.registerSingleton<SignInUseCase>(SignInUseCase());
  sl.registerSingleton<SignUpUseCase>(SignUpUseCase());
  sl.registerSingleton<AuthUserUseCase>(AuthUserUseCase());
  sl.registerSingleton<CreateChatUseCase>(CreateChatUseCase());
  sl.registerSingleton<DeleteChatUseCase>(DeleteChatUseCase());
  sl.registerSingleton<UpdateChatUseCase>(UpdateChatUseCase());
  sl.registerSingleton<GetChatUseCase>(GetChatUseCase());
  sl.registerSingleton<GetAllChatSummariesUseCase>(
      GetAllChatSummariesUseCase());
  sl.registerSingleton<UpdateUserUsecase>(UpdateUserUsecase());
}
