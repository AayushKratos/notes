import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:note/Screen/forgot_pass.dart';
import 'package:note/Screen/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isLoading = false;

  signIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text, password: password.text);
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.code);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
    setState(() {
      isLoading = false;
    });
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
                    controller: email,
                    decoration: InputDecoration(hintText: 'Enter email ID'),
                  ),
                  TextField(
                    controller: password,
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
                      child: Text('Forgot Password?'))
                ],
              ),
            ),
          );
  }
}
