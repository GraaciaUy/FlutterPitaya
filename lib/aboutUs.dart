import 'package:flutter/material.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  get formKey => null;

  get style => null;

  @override
  // ignore: prefer_const_constructors
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Form(
                //connect
                key: formKey,
                child: const Column(children: [
                  SizedBox(height: 30),
                  Image(image: AssetImage('asset/AboutUsText.png')),
                  SizedBox(height: 18),
                  Text(
                      'Pitaya Clinic is an interactive tool for farmers who want to learn and diagnose the different diseases, pests and other problems that occur in the Pitaya plant.',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 18),
                  Text(
                      'We created this application as part of our thesis. This interactive tool allows the users to diagnose or at determine of the possible problems occuring in the dragon fruit plant.',
                      style: TextStyle(fontSize: 20)),
                  Image(image: AssetImage('asset/AboutUs.png')),
                ]))));
  }
}
