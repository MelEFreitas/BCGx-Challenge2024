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
