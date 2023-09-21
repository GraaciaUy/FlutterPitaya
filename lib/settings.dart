import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});


  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  get formKey => null;



  @override
  Widget build(BuildContext context) {

    return Scaffold(
     backgroundColor: const Color(0xFF90EE90),
     body: SingleChildScrollView(
            child: Form(
                //connect
                key: formKey,
                child: const Column(children: [
                  Image(image: AssetImage('asset/SettingsText.png')),
                  const Image(image: AssetImage('asset/PitayaLogo.png')),
                  Text(
                      'Profile Button',
                      style: TextStyle(fontSize: 20)),
                      Text(
                      'About Us Button',
                      style: TextStyle(fontSize: 20)),
                      Text(
                      'Login Button',
                      style: TextStyle(fontSize: 20)),
                ]))));
  }
}
