// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:frontend/presentation/auth/cubits/sign_in/sign_in_cubit.dart';
// import 'package:frontend/presentation/auth/cubits/sign_up/sign_up_cubit.dart';
// import 'package:frontend/presentation/auth/cubits/sign_up/sign_up_state.dart';

// class SignUpScreen extends StatelessWidget {
//   SignUpScreen({super.key});

//   final TextEditingController _emailCon = TextEditingController();
//   final TextEditingController _passwordCon = TextEditingController();
//   final TextEditingController _roleCon = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocListener<SignUpCubit, SignUpState>(
//         listener: (context, signUpState) {
//           if (signUpState is SignUpStateFailure) {
//             ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text(signUpState.errorMessage)));
//           } else if (signUpState is SignUpStateSuccess) {
//             final email = _emailCon.text.trim();
//             final password = _passwordCon.text.trim();
//             context.read<SignInCubit>().signIn(email, password);
//           }
//         },
//         child: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 _signUp(),
//                 const SizedBox(
//                   height: 50,
//                 ),
//                 _emailField(),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 _password(),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 _role(),
//                 const SizedBox(
//                   height: 60,
//                 ),
//                 _signUpButton(),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 _signInText(context)
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _signUp() {
//     return const Text(
//       'Sign Up',
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

//   Widget _role() {
//     return TextField(
//       controller: _roleCon,
//       decoration: const InputDecoration(hintText: 'Role'),
//     );
//   }

//   Widget _signUpButton() {
//     return BlocBuilder<SignUpCubit, SignUpState>(
//         builder: (context, signUpState) {
//       bool isLoading = signUpState is SignUpStateLoading;

//       return ElevatedButton(
//         onPressed: isLoading
//             ? null
//             : () {
//                 // TODO: add form validation
//                 final email = _emailCon.text.trim();
//                 final password = _passwordCon.text.trim();
//                 final role = _roleCon.text.trim();

//                 context.read<SignUpCubit>().signUp(email, password, role);
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
//             : const Text('Sign Up'),
//       );
//     });
//   }

//   Widget _signInText(BuildContext context) {
//     return Text.rich(
//       TextSpan(children: [
//         const TextSpan(
//             text: "Already have account?",
//             style: TextStyle(
//                 color: Color(0xff3B4054), fontWeight: FontWeight.w500)),
//         TextSpan(
//             text: 'Sign In',
//             style: const TextStyle(
//                 color: Color(0xff3461FD), fontWeight: FontWeight.w500),
//             recognizer: TapGestureRecognizer()
//               ..onTap = () {
//                 Navigator.pop(context);
//               })
//       ]),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/auth/cubits/sign_in/sign_in_cubit.dart';
import 'package:frontend/presentation/auth/cubits/sign_up/sign_up_cubit.dart';
import 'package:frontend/presentation/auth/cubits/sign_up/sign_up_state.dart';
import 'package:frontend/presentation/auth/widgets/auth_layout.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();
  final TextEditingController _roleCon = TextEditingController();

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
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, signUpState) {
        if (signUpState is SignUpStateFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(signUpState.errorMessage)));
        } else if (signUpState is SignUpStateSuccess) {
          final email = _emailCon.text.trim();
          final password = _passwordCon.text.trim();
          context.read<SignInCubit>().signIn(email, password);
        }
      },
      child: AuthLayout(
        title: 'Sign Up',
        formFields: [
          _buildTextField(_emailCon, 'Email'),
          const SizedBox(height: 20),
          _buildTextField(_passwordCon, 'Password', obscureText: true),
          const SizedBox(height: 20),
          _buildTextField(_roleCon, 'Role'),
        ],
        switchText: "Already have an account? ",
        switchButtonText: 'Sign In',
        onSwitchTap: () {
          Navigator.pop(context);
        },
        actionButtonText: 'Sign Up',
        onActionTap: () {
          final email = _emailCon.text.trim();
          final password = _passwordCon.text.trim();
          final role = _roleCon.text.trim();
          context.read<SignUpCubit>().signUp(email, password, role);
        },
        isLoading: context.watch<SignUpCubit>().state is SignUpStateLoading,
      ),
    );
  }
}
