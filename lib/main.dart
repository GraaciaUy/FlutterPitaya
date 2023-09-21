import 'package:flutter/material.dart';
import 'package:pitayaclinic/aboutUs.dart';
import 'package:pitayaclinic/login.dart';
import 'package:pitayaclinic/register.dart';
import 'package:pitayaclinic/settings.dart';
import 'package:pitayaclinic/uploadImage.dart';
//import 'package:pitayaclinic/UploadImage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // page
      home: const MyHomePage(), // Proceed register
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the disp
      //lay can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  // variable

  final formKey = GlobalKey<FormState>();

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF90EE90),
        body: SingleChildScrollView(
          child: Form(
            //connect
            key: formKey,
            child: Column(children: [
              const Image(image: AssetImage('asset/PitayaLogo.png')),
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
              SizedBox(
                height: 40,
                width: 150,
                child: ElevatedButton(
                  style: style,
                  onPressed: () {
                    print(email.text);
                    print(password.text);
                  },
                  child: const Text('Login'),
                ),
              ),
              const Text('Dont have an account?',
                  style: TextStyle(fontSize: 16)),
              SizedBox(
                height: 40,
                width: 1,
                child: ElevatedButton(
                  style: style,
                  onPressed: () {},
                  child: const Text('Create Account'),
                ),
              ),
              const Text('Continue without an account?',
                  style: TextStyle(fontSize: 16)),
              SizedBox(
                height: 40,
                width: 150,
                child: ElevatedButton(
                  style: style,
                  onPressed: () {},
                  child: const Text('Continue'),
                ),
              ),
            ]),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ));
  }
}
