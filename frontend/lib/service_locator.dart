import 'package:frontend/core/infrastructure/secure_storage_service.dart';
import 'package:frontend/core/network/dio_client.dart';
import 'package:frontend/data/repositories/auth/auth.dart';
import 'package:frontend/data/sources/auth/auth_api_service.dart';
import 'package:frontend/data/sources/auth/auth_local_service.dart';
import 'package:frontend/domain/repositories/auth/auth.dart';
import 'package:frontend/domain/usecases/auth/auth_user.dart';
import 'package:frontend/domain/usecases/auth/sign_in.dart';
import 'package:frontend/domain/usecases/auth/sign_up.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<DioClient>(DioClient());

  sl.registerSingleton<SecureStorageService>(SecureStorageServiceImpl());

  sl.registerSingleton<AuthApiService>(AuthApiServiceImpl());

  sl.registerSingleton<AuthLocalService>(AuthLocalServiceImpl());

  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());

  sl.registerSingleton<SignInUseCase>(SignInUseCase());

  sl.registerSingleton<SignUpUseCase>(SignUpUseCase());

  sl.registerSingleton<AuthUserUseCase>(AuthUserUseCase());
}
