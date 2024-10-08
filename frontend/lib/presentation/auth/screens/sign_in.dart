// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:frontend/presentation/auth/cubits/auth/auth_cubit.dart';
// import 'package:frontend/presentation/auth/cubits/sign_in/sign_in_cubit.dart';
// import 'package:frontend/presentation/auth/cubits/sign_in/sign_in_state.dart';
// import 'package:frontend/presentation/auth/screens/sign_up.dart';

// class SignInScreen extends StatelessWidget {
//   SignInScreen({super.key});

//   final TextEditingController _emailCon = TextEditingController();
//   final TextEditingController _passwordCon = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocListener<SignInCubit, SignInState>(
//         listener: (context, signInState) {
//           if (signInState is SignInStateFailure) {
//             ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text(signInState.errorMessage)));
//           } else if (signInState is SignInStateSuccess) {
//             context.read<AuthCubit>().authenticateUser(signInState.token);
//             if (Navigator.of(context).canPop()) {
//               Navigator.of(context).pop();
//             }
//           }
//         },
//         child: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 _signIn(),
//                 const SizedBox(
//                   height: 50,
//                 ),
//                 _emailField(),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 _password(),
//                 const SizedBox(
//                   height: 60,
//                 ),
//                 _signInButton(),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 _signUpText(context)
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _signIn() {
//     return const Text(
//       'Sign In',
//       style: TextStyle(
//           color: Color(0xff2A4ECA), fontWeight: FontWeight.bold, fontSize: 32),
//     );
//   }

//   Widget _emailField() {
//     return TextField(
//       controller: _emailCon,
//       decoration: const InputDecoration(hintText: 'Email'),
//     );
//   }

//   Widget _password() {
//     return TextField(
//       controller: _passwordCon,
//       decoration: const InputDecoration(hintText: 'Password'),
//     );
//   }

//   Widget _signInButton() {
//     return BlocBuilder<SignInCubit, SignInState>(
//         builder: (context, signInState) {
//       bool isLoading = signInState is SignInStateLoading;

//       return ElevatedButton(
//         onPressed: isLoading
//             ? null
//             : () {
//                 // TODO: add form validation
//                 final email = _emailCon.text.trim();
//                 final password = _passwordCon.text.trim();

//                 context.read<SignInCubit>().signIn(email, password);
//               },
//         style: ElevatedButton.styleFrom(
//           padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(30),
//           ),
//         ),
//         child: isLoading
//             ? const SizedBox(
//                 height: 20,
//                 width: 20,
//                 child: CircularProgressIndicator(
//                   color: Colors.white,
//                   strokeWidth: 2.0,
//                 ),
//               )
//             : const Text('Sign In'),
//       );
//     });
//   }

//   Widget _signUpText(BuildContext context) {
//     return Text.rich(
//       TextSpan(children: [
//         const TextSpan(
//             text: "Don't you have account?",
//             style: TextStyle(
//                 color: Color(0xff3B4054), fontWeight: FontWeight.w500)),
//         TextSpan(
//             text: 'Sign Up',
//             style: const TextStyle(
//                 color: Color(0xff3461FD), fontWeight: FontWeight.w500),
//             recognizer: TapGestureRecognizer()
//               ..onTap = () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => SignUpScreen(),
//                     ));
//               })
//       ]),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:frontend/presentation/auth/cubits/sign_in/sign_in_cubit.dart';
import 'package:frontend/presentation/auth/cubits/sign_in/sign_in_state.dart';
import 'package:frontend/presentation/auth/screens/sign_up.dart';
import 'package:frontend/presentation/auth/widgets/auth_layout.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();

  Widget _buildTextField(TextEditingController controller, String hintText,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInCubit, SignInState>(
      listener: (context, signInState) {
        if (signInState is SignInStateFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(signInState.errorMessage)));
        } else if (signInState is SignInStateSuccess) {
          context.read<AuthCubit>().authenticateUser(signInState.token);
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        }
      },
      child: AuthLayout(
        title: 'Sign In',
        formFields: [
          _buildTextField(_emailCon, 'Email'),
          const SizedBox(height: 20),
          _buildTextField(_passwordCon, 'Password', obscureText: true),
        ],
        switchText: "Don't have an account? ",
        switchButtonText: 'Sign Up',
        onSwitchTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignUpScreen(),
            ),
          );
        },
        actionButtonText: 'Sign In',
        onActionTap: () {
          final email = _emailCon.text.trim();
          final password = _passwordCon.text.trim();
          context.read<SignInCubit>().signIn(email, password);
        },
        isLoading: context.watch<SignInCubit>().state is SignInStateLoading,
      ),
    );
  }
}
