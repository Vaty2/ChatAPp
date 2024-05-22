// import 'package:chat_zone/components/my_button.dart';
// import 'package:chat_zone/components/my_text_field.dart';
// import 'package:chat_zone/services/auth/auth_service.dart';
// import 'package:flutter/material.dart';
// import 'package:path/path.dart';
// import 'package:provider/provider.dart';

// class LoginPage extends StatefulWidget {
//   final void Function()? onTap;
//   const LoginPage({super.key, required this.onTap});

//   @override
//   State<LoginPage> createState() => _LonginPageState();
// }

// class _LonginPageState extends State<LoginPage> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   void signIn() async {
//     final authService = Provider.of<AuthService>(context, listen: false);
//     try {
//       await authService.signInWithEmailandPassword(
//           emailController.text, passwordController.text);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(
//           e.toString(),
//         ),
//       ));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade300,
//       body: SafeArea(
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 25.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(
//                   Icons.message,
//                   size: 80,
//                   color: Colors.grey,
//                 ),
//                 // ClipRRect(
//                 //   borderRadius: BorderRadius.circular(10),
//                 //   child: Image.network('https://i.pinimg.com/564x/63/ac/0f/63ac0f1f6b43cadafa12728274fa1075.jpg'),
//                 // ),
//                 const SizedBox(
//                   height: 50,
//                 ),
//                 const Text(
//                   'Welcome Back',
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 const SizedBox(
//                   height: 25,
//                 ),
//                 MyTextField(
//                     controller: emailController,
//                     hintText: 'Email',
//                     obsecureText: false),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 MyTextField(
//                     controller: passwordController,
//                     hintText: 'Password',
//                     obsecureText: true),
//                 const SizedBox(
//                   height: 25,
//                 ),
//                 MyButton(
//                     onTap: () {
//                       signIn();
//                     },
//                     text: "Sign In"),
//                 const SizedBox(
//                   height: 25,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text("Not a member?"),
//                     GestureDetector(
//                       onTap: widget.onTap,
//                       child: const Text(
//                         "Register now",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:chat_zone/components/my_button.dart';
import 'package:chat_zone/components/my_text_field.dart';
import 'package:chat_zone/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LonginPageState();
}

class _LonginPageState extends State<LoginPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signInWithEmailandPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          e.toString(),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon(
                //   Icons.message,
                //   size: 80,
                //   color: Colors.grey,
                // ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network('https://i.pinimg.com/564x/63/ac/0f/63ac0f1f6b43cadafa12728274fa1075.jpg',),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Welcome Back',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 25,
                ),
                MyTextField(
                    controller: nameController,
                    hintText: 'User Name',
                    obsecureText: false),
                    const SizedBox(
                  height: 10,
                ),
                MyTextField(
                    controller: emailController,
                    hintText: 'Enter Email',
                    obsecureText: false),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                    controller: passwordController,
                    hintText: 'Enter Password',
                    obsecureText: true),
                const SizedBox(
                  height: 25,
                ),
                MyButton(
                    onTap: () {
                      signIn();
                    },
                    text: "Sign In",
                    ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Not a member?"),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Register now",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
