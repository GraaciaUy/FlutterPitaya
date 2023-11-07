import 'package:flutter/material.dart';
import 'package:pitayaclinic/services/authservice.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  get formKey => null;

  Widget buildTextWithBorder(String text) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(image: AssetImage('asset/PitayaLogo.png')),
              SizedBox(height: 25), // Spacing between the image and "ABOUT US"
              buildTextWithBorder('ABOUT US'), // Border around "ABOUT US"
              SizedBox(height: 16), // Spacing between "ABOUT US" and "LOG OUT"
              InkWell(
                onTap: () {
                  context.read<AuthService>().signout().then(
                      (value) => Navigator.pushNamed(context, '/mainauth'));
                },
                child:
                    buildTextWithBorder('LOG OUT'), // Border around "LOG OUT"
              )
            ],
          ),
        ),
      ),
    );
  }
}
