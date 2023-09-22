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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF90EE90),
        body: SingleChildScrollView(
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(image: AssetImage('asset/SettingsText.png')),
                      const Image(image: AssetImage('asset/PitayaLogo.png')),
                      const Text('Profile Button',
                          style: TextStyle(fontSize: 20)),
                      const Text('About Us Button',
                          style: TextStyle(fontSize: 20)),
                      const Text('Login Button',
                          style: TextStyle(fontSize: 20)),
                      InkWell(
                        onTap: () {
                          context.read<AuthService>().signout().then((value) =>
                              Navigator.pushNamed(context, '/mainauth'));
                        },
                        child: const Text(
                          'logout',
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    ]))));
  }
}
