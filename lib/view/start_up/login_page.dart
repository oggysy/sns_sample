import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sns_sample/utils/authentication.dart';
import 'package:sns_sample/utils/firestore/users.dart';
import 'package:sns_sample/view/screen.dart';
import 'package:sns_sample/view/start_up/create_account_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text(
                'SNS App',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Container(
                  width: 300,
                  child: TextField(
                    decoration: const InputDecoration(hintText: 'email'),
                    controller: emailController,
                  ),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  decoration: const InputDecoration(hintText: 'password'),
                  controller: passwordController,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: [
                    const TextSpan(text: 'アカウントを作成していない方は'),
                    TextSpan(
                        text: 'こちら',
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) =>
                                        const CreateAccountPage()));
                          }),
                  ],
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              ElevatedButton(
                  onPressed: () async {
                    var result = await Authentication.emailSignIn(
                        email: emailController.text,
                        pass: passwordController.text);
                    if (result is UserCredential) {
                      var _result =
                          await UserFirestore.getUser(result.user!.uid);
                      if (_result == true) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => Screen(),
                          ),
                        );
                      }
                    }
                  },
                  child: Text('emailでログイン'))
            ],
          ),
        ),
      ),
    );
  }
}
