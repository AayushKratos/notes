import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:note/Screen/forgot_pass.dart';
import 'package:note/Screen/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signIn() async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "An error occurred.");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      
      // Optionally, navigate to another page or update the UI here
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "An error occurred during sign-in.");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("Login"),
            ),
            body: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(hintText: 'Enter email ID'),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(hintText: 'Enter password'),
                  ),
                  ElevatedButton(
                      onPressed: (() => signIn()), child: Text('Login')),
                  SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: (() => Get.to(Signup())),
                      child: Text('Register Now')),
                  SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: (() => Get.to(Forgot())),
                      child: Text('Forgot Password?')),
                  SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: signInWithGoogle,
                      child: Text('Sign in with Google')),
                ],
              ),
            ),
          );
  }
}
