import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/auth/cubits/auth_cubit.dart';
import 'package:frontend/presentation/theme/cubits/theme_cubit.dart';
import 'package:frontend/presentation/theme/cubits/theme_state.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(),
        ),
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          final brightness = MediaQuery.of(context).platformBrightness;
          context.read<ThemeCubit>().updateTheme(brightness);
          return MaterialApp(
            title: 'BCGx Challenge',
            theme: ThemeData(primarySwatch: Colors.blue),
            themeMode: themeState.themeMode,
            home: AuthWrapper(),
          );
        }
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        //TODO: add change of screen based on auth behavior
        throw(UnimplementedError());
      }
    );
  }
}