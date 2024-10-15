import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:frontend/presentation/auth/cubits/sign_in/sign_in_cubit.dart';
import 'package:frontend/presentation/auth/cubits/sign_up/sign_up_cubit.dart';
import 'package:frontend/presentation/home/cubits/language/language_cubit.dart';
import 'package:frontend/presentation/home/widgtes/language_switcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  int _selectedRole = 0;

  final List<Map<String, String>> _roles = [
    {"title": "Admin", "description": "Full access to the system"},
    {"title": "Editor", "description": "Can edit and manage content"},
    {"title": "Viewer", "description": "Can only view content"}
  ];

  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();
  final TextEditingController _confirmPasswordCon = TextEditingController();

  final _signUpFormKey = GlobalKey<FormState>();

  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

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

      if (_confirmPasswordCon.text.isEmpty) {
        _confirmPasswordError = localizations.confirmPasswordErrorEmpty;
      } else if (_confirmPasswordCon.text != _passwordCon.text) {
        _confirmPasswordError = localizations.confirmPasswordErrorValid;
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final localizations = AppLocalizations.of(context)!;
    double textFieldWidth = screenWidth > 600 ? 450 : screenWidth * 0.95;
    double boxWidth = 300;
    final bool isLoading =
        context.watch<SignInCubit>().state is SignInStateLoading ||
            context.watch<SignUpCubit>().state is SignUpStateLoading;

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
          BlocListener<SignUpCubit, SignUpState>(
              listener: (context, state) async {
            if (state is SignUpStateFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.errorMessage)));
            } else if (state is SignUpStateSuccess) {
              final email = _emailCon.text.trim();
              final password = _passwordCon.text.trim();
              await context.read<SignInCubit>().signIn(email, password);
            }
          }),
          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthStateAuthenticated) {
                Navigator.of(context).pop();
              }
            },
          ),
          BlocListener<LanguageCubit, Locale>(
            listener: (context, state) {
              if (_emailError != null ||
                  _passwordError != null ||
                  _confirmPasswordError != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _validateForm(AppLocalizations.of(context)!);
                });
              }
            },
          ),
        ],
        child: Form(
          key: _signUpFormKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      localizations.signUp,
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
                          errorText: _emailError,
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
                          errorText: _passwordError,
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
                    SizedBox(
                      width: textFieldWidth,
                      child: TextFormField(
                        controller: _confirmPasswordCon,
                        obscureText: !_isConfirmPasswordVisible,
                        decoration: InputDecoration(
                          labelText: localizations.confirmPassword,
                          hintText: localizations.confirmPasswordHint,
                          border: const OutlineInputBorder(),
                          errorText: _confirmPasswordError,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(localizations.selectRole),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _roles.asMap().entries.map((entry) {
                          int index = entry.key;
                          String roleTitle = entry.value["title"]!;
                          String roleDescription = entry.value["description"]!;
                          return MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedRole = index;
                                });
                              },
                              child: Container(
                                width: boxWidth,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: _selectedRole == index
                                      ? Colors.blue.shade100
                                      : Colors.grey.shade200,
                                  border: Border.all(
                                    color: _selectedRole == index
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      roleTitle,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(roleDescription),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: RichText(
                          text: TextSpan(
                            text: localizations.alreadyHaveAccount,
                            style: const TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: localizations.signIn,
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
                                    _passwordError == null &&
                                    _confirmPasswordError == null) {
                                  final email = _emailCon.text.trim();
                                  final password = _passwordCon.text.trim();
                                  final role = _roles[_selectedRole]['title']!;
                                  context
                                      .read<SignUpCubit>()
                                      .signUp(email, password, role);
                                } else {
                                  log('Sign Up form validation failed');
                                }
                              },
                              child: Text(
                                localizations.signUp,
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
