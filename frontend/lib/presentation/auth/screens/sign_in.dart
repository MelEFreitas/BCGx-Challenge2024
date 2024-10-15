import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:frontend/presentation/auth/cubits/sign_in/sign_in_cubit.dart';
import 'package:frontend/presentation/auth/screens/sign_up.dart';
import 'package:frontend/presentation/home/cubits/language/language_cubit.dart';
import 'package:frontend/presentation/home/widgtes/language_switcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isPasswordVisible = false;

  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();

  final _signInFormKey = GlobalKey<FormState>();

  String? _emailError;
  String? _passwordError;

  void _validateForm(AppLocalizations localizations) {
    setState(() {
      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
      if (_emailCon.text.isEmpty) {
        _emailError = localizations.emailErrorEmpty;
      } else if (!emailRegex.hasMatch(_emailCon.text)) {
        _emailError = localizations.emailErrorValid;
      } else {
        _emailError = null;
      }

      final passwordRegex =
          RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');

      if (_passwordCon.text.isEmpty) {
        _passwordError = localizations.passwordErrorEmpty;
      } else if (!passwordRegex.hasMatch(_passwordCon.text)) {
        _passwordError = localizations.passwordErrorValid;
      } else {
        _passwordError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final localizations = AppLocalizations.of(context)!;
    double textFieldWidth = screenWidth > 600 ? 450 : screenWidth * 0.95;
    final bool isLoading =
        context.watch<SignInCubit>().state is SignInStateLoading;

    return Scaffold(
      appBar: AppBar(
        actions: const [
          LanguageSwitcherButton(),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<SignInCubit, SignInState>(
            listener: (context, state) async {
              if (state is SignInStateFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.errorMessage)));
              } else if (state is SignInStateSuccess) {
                await context.read<AuthCubit>().authenticateUser();
              }
            },
          ),
          BlocListener<LanguageCubit, Locale>(
            listener: (context, state) {
              if (_emailError != null || _passwordError != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _validateForm(AppLocalizations.of(context)!);
                });
              }
            },
          ),
        ],
        child: Form(
          key: _signInFormKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      localizations.signIn,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: textFieldWidth,
                      child: TextFormField(
                        controller: _emailCon,
                        decoration: InputDecoration(
                          labelText: localizations.email,
                          hintText: localizations.emailHint,
                          border: const OutlineInputBorder(),
                          errorText: _emailError, // Error message from state
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: textFieldWidth,
                      child: TextFormField(
                        controller: _passwordCon,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: localizations.password,
                          hintText: localizations.passwordHint,
                          border: const OutlineInputBorder(),
                          errorText: _passwordError, // Error message from state
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: localizations.dontHaveAccount,
                            style: const TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: localizations.signUp,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 16),
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                _validateForm(localizations);

                                if (_emailError == null &&
                                    _passwordError == null) {
                                  final email = _emailCon.text.trim();
                                  final password = _passwordCon.text.trim();
                                  context
                                      .read<SignInCubit>()
                                      .signIn(email, password);
                                } else {
                                  log('Sign In form validation failed');
                                }
                              },
                              child: Text(
                                localizations.signIn,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
