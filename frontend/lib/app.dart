import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:frontend/presentation/auth/cubits/sign_in/sign_in_cubit.dart';
import 'package:frontend/presentation/auth/cubits/sign_up/sign_up_cubit.dart';
import 'package:frontend/presentation/auth/screens/sign_in.dart';
import 'package:frontend/presentation/home/cubits/theme/theme_cubit.dart';
import 'package:frontend/presentation/home/cubits/theme/theme_state.dart';
import 'package:frontend/presentation/home/screens/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
        BlocProvider<SignInCubit>(
          create: (context) => SignInCubit(),
        ),
        BlocProvider<SignUpCubit>(
          create: (context) => SignUpCubit(),
        ),
      ],
      child:
          BlocBuilder<ThemeCubit, ThemeState>(builder: (context, themeState) {
        final brightness = MediaQuery.of(context).platformBrightness;
        context.read<ThemeCubit>().updateTheme(brightness);
        return MaterialApp(
          title: 'BCGx Challenge',
          theme: ThemeData(primarySwatch: Colors.blue),
          themeMode: themeState.themeMode,
          home: const AuthWrapper(),
        );
      }),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, authState) {
      if (authState is AuthStateAuthenticated) {
        return HomeScreen();
      } else {
        return SignInScreen();
      }
    });
  }
}
