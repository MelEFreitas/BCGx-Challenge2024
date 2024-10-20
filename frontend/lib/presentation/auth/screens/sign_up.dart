import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/theme.dart';
import 'package:frontend/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:frontend/presentation/auth/cubits/sign_in/sign_in_cubit.dart';
import 'package:frontend/presentation/auth/cubits/sign_up/sign_up_cubit.dart';
import 'package:frontend/presentation/auth/widgets/auth_button.dart';
import 'package:frontend/presentation/auth/widgets/auth_navigation_text.dart';
import 'package:frontend/presentation/auth/widgets/common_text_field.dart';
import 'package:frontend/presentation/auth/widgets/role_selector.dart';
import 'package:frontend/presentation/home/cubits/language/language_cubit.dart';
import 'package:frontend/presentation/home/widgtes/language_switcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// A screen that allows users to sign up for an account.
///
/// This screen includes fields for email, password, and confirmation password,
/// as well as a role selector. It provides validation for input fields
/// and handles the signup process via the SignUpCubit. Users can also
/// navigate to the sign-in screen from this page.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  int _selectedRole = 0;

  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();
  final TextEditingController _confirmPasswordCon = TextEditingController();

  final _signUpFormKey = GlobalKey<FormState>();

  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  /// Validates the input fields in the form.
  ///
  /// This method checks if the email is empty or has an invalid format,
  /// if the password meets the required criteria, and if the confirm
  /// password matches the password.
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
    final bool isLoading =
        context.watch<SignInCubit>().state is SignInStateLoading ||
            context.watch<SignUpCubit>().state is SignUpStateLoading;

    final List<Map<String, String>> roles = [
      {
        "title": localizations.userTitle,
        "description": localizations.userDescription
      },
      {
        "title": localizations.managerTitle,
        "description": localizations.managerDescription
      },
      {
        "title": localizations.envAnalystTitle,
        "description": localizations.envAnalystDescription
      },
    ];

    final List<String> defaultRoles = ["User", "Manager", "Environmental Analyst"];

    return Scaffold(
      backgroundColor: ThemeColors.lightGrey,
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
        child: Stack(
          children: [
            Form(
              key: _signUpFormKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Text(
                          localizations.signUp,
                          style: const TextStyle(
                            color: ThemeColors.black,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: textFieldWidth,
                          child: CommonTextField(
                            controller: _emailCon,
                            labelText: localizations.email,
                            hintText: localizations.emailHint,
                            errorText: _emailError,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: textFieldWidth,
                          child: CommonTextField(
                            controller: _passwordCon,
                            labelText: localizations.password,
                            hintText: localizations.passwordHint,
                            errorText: _passwordError,
                            isVisible: _isPasswordVisible,
                            onToggleVisibility: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            hasVisibilityToggle: true,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: textFieldWidth,
                          child: CommonTextField(
                            controller: _confirmPasswordCon,
                            labelText: localizations.confirmPassword,
                            hintText: localizations.confirmPasswordHint,
                            errorText: _confirmPasswordError,
                            isVisible: _isConfirmPasswordVisible,
                            onToggleVisibility: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                            hasVisibilityToggle: true,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          localizations.selectRole,
                          style: const TextStyle(
                            fontSize: 17
                          ),
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: RoleSelector(
                              roles: roles,
                              selectedRole: _selectedRole,
                              onRoleSelected: (index) {
                                setState(() {
                                  _selectedRole = index;
                                });
                              },
                            )),
                        const SizedBox(height: 20),
                        AuthNavigationText(
                          primaryText: localizations.alreadyHaveAccount,
                          actionText: localizations.signIn,
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: isLoading
                              ? const CircularProgressIndicator(
                                color: ThemeColors.logoOrange,
                              )
                              : AuthButton(
                                  buttonText: localizations.signUp,
                                  onPressed: () {
                                    _validateForm(localizations);
                                    if (_emailError == null &&
                                        _passwordError == null &&
                                        _confirmPasswordError == null) {
                                      final email = _emailCon.text.trim();
                                      final password = _passwordCon.text.trim();
                                      final role = defaultRoles[_selectedRole];
                                      context
                                          .read<SignUpCubit>()
                                          .signUp(email, password, role);
                                    }
                                  },
                                  isLoading: isLoading,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
