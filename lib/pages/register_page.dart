import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found_items/components/inputfeild.dart';
import 'package:lost_and_found_items/components/button.dart';
import 'package:lost_and_found_items/components/imageholder.dart';
import 'package:lost_and_found_items/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //sign user up
  Future<void> signUserUp(String email, password) async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // creating user
    try {
      // check if password is confirmed
      if (passwordController.text == confirmPasswordController.text) {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // create document
        await _fireStore.collection('user').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': email,
          'username': emailController.text.split('@')[0] //  initial username
        });
      } else {
        // show error message
        showErrorMessage("Passwords don't match!");
      }

      // create new document

      // pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);

      // show error to the user
      showErrorMessage(e.code);
    }
  }

  // show error message
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
                // logo
                const Icon(
                  Icons.abc,
                  size: 100,
                ),
                // Welcome text
                const SizedBox(height: 25),
                const Text(
                  "Create an account",
                  style: TextStyle(
                    color: Color.fromARGB(255, 131, 126, 126),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 15),
                // email text field
                InputFeild(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15),
                // password text field
                InputFeild(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 10),
                // confirm password text field
                InputFeild(
                  controller: confirmPasswordController,
                  hintText: "Confirm Password",
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 25),
                // sign up button
                Button(
                    onTap: () => signUserUp(
                        emailController.text, passwordController.text),
                    text: "Sign Up"),
                // continue with google
                const SizedBox(height: 25),
                // horizontal divider with text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          "Or continue with",
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                // Google sign-in image
                GestureDetector(
                  onTap: () => AuthService().signInwithGoogle(),
                  child: const ImageHolder(
                    imagepath: 'lib/images/google.png',
                  ),
                ),
                const SizedBox(height: 25),
                // register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    const SizedBox(width: 4),
                    // on click
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Login Now?",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
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
