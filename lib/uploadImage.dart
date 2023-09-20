import 'package:flutter/material.dart';

class UploadImagePage extends StatefulWidget {
  const UploadImagePage({super.key});

  @override
  State<UploadImagePage> createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  get formKey => null;

  get style => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF90EE90),
        body: SingleChildScrollView(
            child: Form(
                //connect
                key: formKey,
                child: const Column(children: [
                  Image(image: AssetImage('asset/UploadPhoto.png')),
                  Text('You want to upload a photo?',
                      style: TextStyle(fontSize: 20)),
                ]))));
  }
}
