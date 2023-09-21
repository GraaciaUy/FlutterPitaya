import 'package:flutter/material.dart';

class registerPage extends StatefulWidget {
  const registerPage({super.key});

  @override
  State<registerPage> createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  get formKey => null;

  get style => null;

  get email => null;

  get password => null;

  @override
  // ignore: prefer_const_constructors
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF90EE90),
        body: SingleChildScrollView(
            child: Form(
                //connect
                key: formKey,
                child: Column(children: [
                  const Image(image: AssetImage('asset/RegisterText.png')),
                  const Image(image: AssetImage('asset/PitayaWelcome.png')),
                  TextField(
                    controller: email,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Email',
                    ),
                  ),
                  TextField(
                    controller: password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Password',
                    ),
                  ),
                  TextField(
                    controller: password,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Confirm Password',
                    ),
                  ),
                  SizedBox(
                    height: 45,
                    width: 150,
                    child: ElevatedButton(
                      style: style,
                      onPressed: () {},
                      child: const Text('Register'),
                    ),
                  ),
                  const Text('Already have an account?',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(
                    height: 45,
                    width: 150,
                    child: ElevatedButton(
                      style: style,
                      onPressed: () {},
                      child: const Text('Login'),
                    ),
                  ),
                ]))));
  }
}
