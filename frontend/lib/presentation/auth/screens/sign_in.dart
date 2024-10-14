import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:frontend/presentation/auth/cubits/sign_in/sign_in_cubit.dart';
import 'package:frontend/presentation/auth/screens/sign_up.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isPasswordVisible = false;

  // Controllers for the text input fields
  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();

  final _signInFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Get the screen width
    final screenWidth = MediaQuery.of(context).size.width;

    // Set a fixed width for text fields and boxes based on screen size
    double textFieldWidth = screenWidth > 600 ? 450 : screenWidth * 0.95;

    return Scaffold(
      body: BlocListener<SignInCubit, SignInState>(
        listener: (context, state) async {
          if (state is SignInStateFailure) {
            ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
          else if (state is SignInStateSuccess) {
            await context.read<AuthCubit>().authenticateUser();
          }
        },
        child: Form(
          key: _signInFormKey,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                    height: 40), // Add some spacing at the top if needed
                const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 32, // Make the font size large
                    fontWeight: FontWeight.bold, // Make the title bold
                  ),
                  textAlign: TextAlign.center, // Center the text
                ),
                const SizedBox(height: 20),
                // Email Input Field
                SizedBox(
                  width: textFieldWidth,
                  child: TextFormField(
                    controller: _emailCon,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      border: OutlineInputBorder(),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: (value) {
                      // Regular expression for email validation
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                      if (value == null || value.isEmpty) {
                        return 'Email cannot be empty';
                      } else if (!emailRegex.hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;  // If valid, return null
                    },
                  ),

                ),
                const SizedBox(height: 20),
                // Password Input Field
                SizedBox(
                  width: textFieldWidth,
                  child: TextFormField(
                    controller: _passwordCon,
                    obscureText: !_isPasswordVisible,  // Control password visibility
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      border: const OutlineInputBorder(),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;  // Toggle password visibility
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password cannot be empty';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Already have an account? Sign In (Clickable)
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
                      text: const TextSpan(
                        text: 'Don\'t have an account? ',
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
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
                // Sign Up Button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      backgroundColor: Colors.blue, // Button background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // Rounded edges
                      ),
                    ),
                    onPressed: () {
                      if (_signInFormKey.currentState!.validate()) {
                        final email = _emailCon.text.trim();
                        final password = _passwordCon.text.trim();
          
                        // Performing the sign-up action
                        context.read<SignInCubit>().signIn(email, password);
                      }
                      else {
                        log('Sign In form validation failed');
                      }
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                          fontSize:
                              18, // Make the text inside the button larger
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
    );
  }
}
