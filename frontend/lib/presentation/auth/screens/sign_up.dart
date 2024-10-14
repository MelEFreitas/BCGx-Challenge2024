import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:frontend/presentation/auth/cubits/sign_in/sign_in_cubit.dart';
import 'package:frontend/presentation/auth/cubits/sign_up/sign_up_cubit.dart';

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

  // Controllers for the text input fields
  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();
  final TextEditingController _confirmPasswordCon = TextEditingController();

  final _signUpFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Get the screen width
    final screenWidth = MediaQuery.of(context).size.width;

    // Set a fixed width for text fields and boxes based on screen size
    double textFieldWidth = screenWidth > 600 ? 450 : screenWidth * 0.95;
    double boxWidth = 300;

    return Scaffold(
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
            }
          ),
          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthStateAuthenticated) {
                Navigator.of(context).pop();
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
                    const SizedBox(
                        height: 40), // Add some spacing at the top if needed
                    const Text(
                      'Sign Up',
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
                          final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                          if (value == null || value.isEmpty) {
                            return 'Email cannot be empty';
                          } else if (!emailRegex.hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null; // If valid, return null
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Password Input Field
                    SizedBox(
                      width: textFieldWidth,
                      child: TextFormField(
                        controller: _passwordCon,
                        obscureText:
                            !_isPasswordVisible, // Control password visibility
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
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible =
                                    !_isPasswordVisible; // Toggle password visibility
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
                    // Confirm Password Input Field
                    SizedBox(
                      width: textFieldWidth,
                      child: TextFormField(
                        controller: _confirmPasswordCon,
                        obscureText:
                            !_isConfirmPasswordVisible, // Control confirm password visibility
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          hintText: 'Confirm your password',
                          border: const OutlineInputBorder(),
                          errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible; // Toggle confirm password visibility
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          } else if (value != _passwordCon.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Select Your Role'),
                    const SizedBox(height: 10),
                    // Horizontally scrollable role selection boxes
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
                    // Already have an account? Sign In (Clickable)
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: RichText(
                          text: const TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Sign In',
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
                          backgroundColor:
                              Colors.blue, // Button background color
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // Rounded edges
                          ),
                        ),
                        onPressed: () {
                          if (_signUpFormKey.currentState!.validate()) {
                            final email = _emailCon.text.trim();
                            final password = _passwordCon.text.trim();
                            final confirmPassword =
                                _confirmPasswordCon.text.trim();
                            final role = _roles[_selectedRole]['title']!;

                            // Performing the sign-up action
                            context
                                .read<SignUpCubit>()
                                .signUp(email, password, role);
                          } else {
                            log('Sign Up form validation failed');
                          }
                        },
                        child: const Text(
                          'Sign Up',
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
        ),
      ),
    );
  }
}
