import 'package:flutter/material.dart';
import 'package:pitayaclinic/login.dart';
import 'package:pitayaclinic/services/authservice.dart';
import 'package:provider/provider.dart';

class registerPage extends StatefulWidget {
  const registerPage({super.key});

  @override
  State<registerPage> createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  final formKey = GlobalKey<FormState>();

  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController verpassword = TextEditingController();
  final TextEditingController firtsname = TextEditingController();
  final TextEditingController lastname = TextEditingController();

  @override
  // ignore: prefer_const_constructors
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: SingleChildScrollView(
            child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Form(
                //connect
                key: formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // const Image(image: AssetImage('asset/RegisterText.png')),
                      // const Image(image: AssetImage('asset/PitayaWelcome.png')),
                      Text(
                        'Register',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 160, 160, 160),
                            fontSize: MediaQuery.of(context).size.width / 8,
                            fontWeight: FontWeight.w400),
                      ),

                      SizedBox(
                        height: MediaQuery.of(context).size.width / 16,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.35,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'First Name',
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 160, 160, 160),
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              32,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width / 32,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    controller: firtsname,
                                    maxLines: null,
                                    keyboardType: TextInputType.name,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'This is a required field.';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 2,
                                              style: BorderStyle.solid,
                                              color: Color.fromARGB(
                                                  155, 236, 236, 236)),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        errorStyle: const TextStyle(
                                          fontSize: 0,
                                          height: 0.3,
                                          color:
                                              Color.fromARGB(255, 255, 33, 17),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                          borderSide: const BorderSide(
                                              width: 2,
                                              style: BorderStyle.solid,
                                              color: Color.fromARGB(
                                                  255, 255, 33, 17)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 2,
                                              style: BorderStyle.solid,
                                              color: Color.fromARGB(
                                                  255, 236, 236, 236)),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                          borderSide: const BorderSide(
                                              width: 2,
                                              style: BorderStyle.solid,
                                              color: Color.fromARGB(
                                                  255, 236, 236, 236)),
                                        ),
                                        filled: true,
                                        contentPadding: EdgeInsets.all(
                                            MediaQuery.of(context).size.width /
                                                32),
                                        labelStyle: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff117AFF),
                                        ),
                                        fillColor: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.35,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Last Name',
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 160, 160, 160),
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              32,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width / 32,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    controller: lastname,
                                    maxLines: null,
                                    keyboardType: TextInputType.name,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'This is a required field.';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 2,
                                              style: BorderStyle.solid,
                                              color: Color.fromARGB(
                                                  155, 236, 236, 236)),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        errorStyle: const TextStyle(
                                          fontSize: 0,
                                          height: 0.3,
                                          color:
                                              Color.fromARGB(255, 255, 33, 17),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                          borderSide: const BorderSide(
                                              width: 2,
                                              style: BorderStyle.solid,
                                              color: Color.fromARGB(
                                                  255, 255, 33, 17)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 2,
                                              style: BorderStyle.solid,
                                              color: Color.fromARGB(
                                                  255, 236, 236, 236)),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                          borderSide: const BorderSide(
                                              width: 2,
                                              style: BorderStyle.solid,
                                              color: Color.fromARGB(
                                                  255, 236, 236, 236)),
                                        ),
                                        filled: true,
                                        contentPadding: EdgeInsets.all(
                                            MediaQuery.of(context).size.width /
                                                32),
                                        labelStyle: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff117AFF),
                                        ),
                                        fillColor: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 24,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Email',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 160, 160, 160),
                                fontSize:
                                    MediaQuery.of(context).size.width / 32,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width / 32,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              controller: email,
                              maxLines: null,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This is a required field.';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2,
                                        style: BorderStyle.solid,
                                        color:
                                            Color.fromARGB(155, 236, 236, 236)),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  errorStyle: const TextStyle(
                                    fontSize: 0,
                                    height: 0.3,
                                    color: Color.fromARGB(255, 255, 33, 17),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    borderSide: const BorderSide(
                                        width: 2,
                                        style: BorderStyle.solid,
                                        color:
                                            Color.fromARGB(255, 255, 33, 17)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2,
                                        style: BorderStyle.solid,
                                        color:
                                            Color.fromARGB(255, 236, 236, 236)),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    borderSide: const BorderSide(
                                        width: 2,
                                        style: BorderStyle.solid,
                                        color:
                                            Color.fromARGB(255, 236, 236, 236)),
                                  ),
                                  filled: true,
                                  contentPadding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width / 32),
                                  labelStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xff117AFF),
                                  ),
                                  fillColor: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 24,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Password',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 160, 160, 160),
                                fontSize:
                                    MediaQuery.of(context).size.width / 32,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width / 32,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              controller: password,
                              obscureText: true,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This is a required field.';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2,
                                        style: BorderStyle.solid,
                                        color:
                                            Color.fromARGB(155, 236, 236, 236)),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  errorStyle: const TextStyle(
                                    fontSize: 0,
                                    height: 0.3,
                                    color: Color.fromARGB(255, 255, 33, 17),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    borderSide: const BorderSide(
                                        width: 2,
                                        style: BorderStyle.solid,
                                        color:
                                            Color.fromARGB(255, 255, 33, 17)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2,
                                        style: BorderStyle.solid,
                                        color:
                                            Color.fromARGB(255, 236, 236, 236)),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    borderSide: const BorderSide(
                                        width: 2,
                                        style: BorderStyle.solid,
                                        color:
                                            Color.fromARGB(255, 236, 236, 236)),
                                  ),
                                  filled: true,
                                  contentPadding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width / 32),
                                  labelStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xff117AFF),
                                  ),
                                  fillColor: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 24,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Verify Password',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 160, 160, 160),
                                fontSize:
                                    MediaQuery.of(context).size.width / 32,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width / 32,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              controller: verpassword,
                              obscureText: true,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This is a required field.';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2,
                                        style: BorderStyle.solid,
                                        color:
                                            Color.fromARGB(155, 236, 236, 236)),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  errorStyle: const TextStyle(
                                    fontSize: 0,
                                    height: 0.3,
                                    color: Color.fromARGB(255, 255, 33, 17),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    borderSide: const BorderSide(
                                        width: 2,
                                        style: BorderStyle.solid,
                                        color:
                                            Color.fromARGB(255, 255, 33, 17)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2,
                                        style: BorderStyle.solid,
                                        color:
                                            Color.fromARGB(255, 236, 236, 236)),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    borderSide: const BorderSide(
                                        width: 2,
                                        style: BorderStyle.solid,
                                        color:
                                            Color.fromARGB(255, 236, 236, 236)),
                                  ),
                                  filled: true,
                                  contentPadding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width / 32),
                                  labelStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xff117AFF),
                                  ),
                                  fillColor: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 24,
                      ),
                      SizedBox(
                        height: 56,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFF90EE90),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  4), // Adjust the radius here
                            ),
                          ),
                          onPressed: () async {
                            if (password.text.trim() ==
                                verpassword.text.trim()) {
                              dynamic done = await context
                                  .read<AuthService>()
                                  .registerUser(
                                      email.text.trim(),
                                      password.text.trim(),
                                      firtsname.text.trim(),
                                      lastname.text.trim());

                              if (done) {
                                goods();
                              } else {
                                _showMessageError('Unexpected Error');
                              }
                            } else {
                              _showMessageError('Password does not match.');
                            }
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height / 56,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account?',
                              style: TextStyle(fontSize: 16)),
                          const SizedBox(
                            width: 8,
                          ),
                          InkWell(
                            child: const Text('Login Here',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.blue)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                              );
                            },
                          )
                        ],
                      )
                    ])),
          ),
        )));
  }

  void backtoLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void goods() async {
    backtoLogin();
    _showMessageSuccess('Account Created, you can now Login.');
  }

  void _showMessageSuccess(msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text(msg,
            style: TextStyle(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontSize: MediaQuery.of(context).size.width / 32,
                fontWeight: FontWeight.w400))));
  }

  void _showMessageError(msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(msg,
            style: TextStyle(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontSize: MediaQuery.of(context).size.width / 32,
                fontWeight: FontWeight.w400))));
  }
}
