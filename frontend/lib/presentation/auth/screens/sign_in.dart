import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/theme.dart';
import 'package:frontend/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:frontend/presentation/auth/cubits/sign_in/sign_in_cubit.dart';
import 'package:frontend/presentation/auth/screens/sign_up.dart';
import 'package:frontend/presentation/auth/widgets/auth_button.dart';
import 'package:frontend/presentation/auth/widgets/auth_navigation_text.dart';
import 'package:frontend/presentation/auth/widgets/common_text_field.dart';
import 'package:frontend/presentation/auth/widgets/vitality_animation.dart';
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
        child: Stack(
          children: [ 
            const VitalityBackground(),
            Form(
              key: _signInFormKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Text(
                          localizations.signIn,
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
                        AuthNavigationText(
                          primaryText: localizations.dontHaveAccount,
                          actionText: localizations.signUp,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpScreen()));
                          },
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: isLoading
                              ? const CircularProgressIndicator(
                                color: ThemeColors.logoOrange,
                              )
                              : AuthButton(
                                  buttonText: localizations.signIn,
                                  onPressed: () {
                                    _validateForm(localizations);
                                    if (_emailError == null &&
                                        _passwordError == null) {
                                      final email = _emailCon.text.trim();
                                      final password = _passwordCon.text.trim();
                                      context
                                          .read<SignInCubit>()
                                          .signIn(email, password);
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
