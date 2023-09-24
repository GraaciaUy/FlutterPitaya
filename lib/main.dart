import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pitayaclinic/dashboard.dart';
import 'package:pitayaclinic/login.dart';
import 'package:pitayaclinic/services/authservice.dart';
import 'package:pitayaclinic/services/databaseService.dart';
import 'package:pitayaclinic/services/models.dart';
import 'package:pitayaclinic/services/route.dart';
import 'package:provider/provider.dart';

//import 'package:pitayaclinic/UploadImage.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  bool useem = false;

  await Firebase.initializeApp();

  if (useem) {
    // [Firestore | 10.0.2.2:8080]
    FirebaseFirestore.instance.settings = const Settings(
      host: '10.0.2.2:8080',
      sslEnabled: false,
      persistenceEnabled: false,
    );

    // [Authentication | 10.0.2.2:9099]
    await FirebaseAuth.instance.useAuthEmulator('10.0.2.2', 9099);

    // [Storage | 10.0.2.2:9199]
    //await FirebaseStorage.instance.useStorageEmulator('10.0.2.2', 9199);
  }

  runApp(const MyApp());
}

// https://transfer.sh/DNd973rJTw/dragonf%20%2897%29.jpg

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Pitaya Clinic',
          onGenerateRoute: RouteGenerator.generateRoute,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            primarySwatch: Colors.blue,
            useMaterial3: true,
          ),
          home: const MainAuthPage()),
    );
  }
}

class MainAuthPage extends StatefulWidget {
  const MainAuthPage({
    Key? key,
  }) : super(key: key);

  @override
  _MainAuthPageState createState() => _MainAuthPageState();
}

class _MainAuthPageState extends State<MainAuthPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseuser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: context.read<AuthService>().authStateChanges,
        builder: (context, snapshot) {
          //return JoinToday();
          if (firebaseuser == null) {
            return const LoginPage();
          } else {
            return MultiProvider(
              providers: [
                StreamProvider<UserData?>.value(
                  value: DatabaseService(
                    uid: firebaseuser.uid,
                  ).userData,
                  initialData: null,
                ),
              ],
              child: const CheckPointStateful(),
            );
          }
        },
      ),
    );
  }
}

class CheckPointStateful extends StatefulWidget {
  const CheckPointStateful({
    Key? key,
  }) : super(key: key);

  @override
  _CheckPointStateful createState() => _CheckPointStateful();
}

String? lastSavedUid;

class _CheckPointStateful extends State<CheckPointStateful> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userData = context.watch<UserData?>();

    return userData != null
        ? const MyHomePage()
        : const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: CircularProgressIndicator(),
              )
            ],
          );
  }
}
