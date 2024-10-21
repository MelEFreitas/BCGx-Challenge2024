import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:frontend/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:frontend/presentation/auth/cubits/sign_in/sign_in_cubit.dart';
import 'package:frontend/presentation/auth/cubits/sign_up/sign_up_cubit.dart';
import 'package:frontend/presentation/auth/screens/sign_in.dart';
import 'package:frontend/presentation/home/cubits/create_chat/create_chat_cubit.dart';
import 'package:frontend/presentation/home/cubits/delete_chat/delete_chat_cubit.dart';
import 'package:frontend/presentation/home/cubits/get_chat/get_chat_cubit.dart';
import 'package:frontend/presentation/home/cubits/get_chat_summaries/get_chat_summaries_cubit.dart';
import 'package:frontend/presentation/home/cubits/language/language_cubit.dart';
import 'package:frontend/presentation/home/cubits/update_chat/update_chat_cubit.dart';
import 'package:frontend/presentation/home/cubits/update_user/update_user_cubit.dart';
import 'package:frontend/presentation/home/screens/home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// The main entry point of the application.
///
/// This widget initializes and provides the necessary [Bloc] instances
/// to the widget tree using [MultiBlocProvider]. It also sets up
/// localization support for the application.
///
/// The following [Bloc]s are provided:
/// - [AuthCubit]: Manages authentication state.
/// - [SignInCubit]: Manages the sign-in process.
/// - [SignUpCubit]: Manages the sign-up process.
/// - [GetChatSummariesCubit]: Fetches chat summaries.
/// - [CreateChatCubit]: Handles the creation of new chats.
/// - [DeleteChatCubit]: Manages chat deletion.
/// - [UpdateChatCubit]: Handles updates to existing chats.
/// - [GetChatCubit]: Retrieves individual chat details.
/// - [UpdateUserCubit]: Manages user updates.
/// - [LanguageCubit]: Handles language changes in the app.
///
/// The application supports English and Portuguese languages.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
        BlocProvider<SignInCubit>(
          create: (context) => SignInCubit(),
        ),
        BlocProvider<SignUpCubit>(
          create: (context) => SignUpCubit(),
        ),
        BlocProvider<GetChatSummariesCubit>(
          create: (context) => GetChatSummariesCubit(),
        ),
        BlocProvider<CreateChatCubit>(
          create: (context) => CreateChatCubit(),
        ),
        BlocProvider<DeleteChatCubit>(
          create: (context) => DeleteChatCubit(),
        ),
        BlocProvider<UpdateChatCubit>(
          create: (context) => UpdateChatCubit(),
        ),
        BlocProvider<GetChatCubit>(
          create: (context) => GetChatCubit(),
        ),
        BlocProvider<UpdateUserCubit>(
          create: (context) => UpdateUserCubit(),
        ),
        BlocProvider<LanguageCubit>(
          create: (context) => LanguageCubit(),
        ),
      ],
      child: BlocBuilder<LanguageCubit, Locale>(
          builder: (context, locale) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              scrollBehavior: const MaterialScrollBehavior().copyWith(
                dragDevices: {PointerDeviceKind.mouse},
              ),
              locale: locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('pt'),
              ],
              title: 'GAIA',
              home: const AuthWrapper(),
            );
          },
      ),
    );
  }
}

/// A widget that wraps the authentication logic and displays the appropriate screen
/// based on the authentication state.
///
/// This widget uses a [BlocBuilder] to listen to the [AuthCubit] and rebuilds
/// the UI based on the current [AuthState].
///
/// If the user is authenticated, it displays the [HomeScreen].
/// If the user is not authenticated, it shows the [SignInScreen].
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, authState) {
      if (authState is AuthStateAuthenticated) {
        return const HomeScreen();
      } else {
        return const SignInScreen();
      }
    });
  }
}
