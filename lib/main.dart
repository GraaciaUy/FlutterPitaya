import 'package:flutter/material.dart';
import 'package:pitayaclinic/login.dart';
import 'package:pitayaclinic/register.dart';

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
      home: const MyHomePage(),  // Proceed register
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
      // so that the display can reflect the updated values. If we changed
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
              const Text('Main Page', style: TextStyle(fontSize: 40)),
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
            height: 75,
            width: 200,
            child: ElevatedButton(
              style: style,
              onPressed: () {
                print(email.text);
                print(password.text);
              },
              child: const Text('Logins'),
            ),
              )
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
