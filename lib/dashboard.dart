import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pitayaclinic/services/databaseService.dart';
import 'package:pitayaclinic/services/models.dart';
import 'package:pitayaclinic/settings.dart';
import 'package:provider/provider.dart';

bool hasimg = false;
late XFile? image;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  final PageController controller = PageController();

  void _onItemTapped(int index) {
    if (controller.hasClients) {
      controller.jumpToPage(
        index,
      );
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller,
          children: const [Home(), Results(), SettingsPage()],
          onPageChanged: (pageIndex) {
            setState(() {
              _selectedIndex = pageIndex;
            });
          },
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: Color.fromARGB(255, 172, 172, 172), width: 0.5)),
          ),
          child: BottomNavigationBar(
            showSelectedLabels: true,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xff117AFF),
            unselectedItemColor: Colors.grey[600],
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: const Icon(
                    Icons.explore,
                    size: 20,
                  ),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: const Icon(
                    Icons.data_array,
                    size: 20,
                  ),
                ),
                label: 'Results',
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: const Icon(
                    Icons.developer_board,
                    size: 20,
                  ),
                ),
                label: 'Serttings',
              ),
            ],
            onTap: _onItemTapped,
            currentIndex: _selectedIndex,
          ),
        ));
  }
}

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseuser = FirebaseAuth.instance.currentUser;

    return MultiProvider(
      providers: [
        StreamProvider<List<Descriptions>>.value(
          value: DatabaseService(
            uid: firebaseuser!.uid,
          ).alldescriptions,
          initialData: [],
        ),
      ],
      child: const Center(
          child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [HomeInner()],
        ),
      )),
    );
  }
}

class HomeInner extends StatefulWidget {
  const HomeInner({
    Key? key,
  }) : super(key: key);

  @override
  _HomeInner createState() => _HomeInner();
}

class _HomeInner extends State<HomeInner> {
  final ImagePicker picker = ImagePicker();

  Future<String> getModelPath(String asset) async {
    final path = '${(await getApplicationSupportDirectory()).path}/$asset';
    await Directory(dirname(path)).create(recursive: true);
    final file = File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(asset);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }

  late final InputImage inputImage;

  bool isDetecting = false;

  String detectedObjectLabel = "";
  String detectedConfidenc = "";

  bool hasDetected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final descriptions = Provider.of<List<Descriptions>>(context);

    return Column(
      children: [
        !isDetecting
            ? Column(
                children: [
                  !hasimg
                      ? const Text('No image selected.')
                      : Image.file(File(image!.path)),
                  const SizedBox(
                    height: 32,
                  ),
                  !hasDetected
                      ? SizedBox(
                          height: 56,
                          width: MediaQuery.of(context).size.width / 2,
                          child: ElevatedButton(
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFF90EE90),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    4), // Adjust the radius here
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                isDetecting = true;
                              });

                              image = await picker.pickImage(
                                  source: ImageSource.gallery);

                              inputImage = InputImage.fromFilePath(image!.path);

                              setState(() {
                                hasimg = true;
                              });

                              final modelPath = await getModelPath(
                                  'asset/ml/rencelv1.tflite');
                              final options = LocalObjectDetectorOptions(
                                mode: DetectionMode.single,
                                modelPath: modelPath,
                                classifyObjects: true,
                                multipleObjects: false,
                              );
                              final objectDetector =
                                  ObjectDetector(options: options);

                              final objects =
                                  await objectDetector.processImage(inputImage);

                              for (DetectedObject detectedObject in objects) {
                                for (Label label in detectedObject.labels) {
                                  setState(() {
                                    isDetecting = false;
                                    detectedObjectLabel = label.text;
                                    hasDetected = true;
                                  });
                                }
                              }

                              objectDetector.close();
                            },
                            child: Text(
                              'Upload Photo',
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height / 56,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            DescriptionsInner(
                              detected: detectedObjectLabel,
                              thisdescription: descriptions
                                  .where(
                                      (obj) => obj.name == detectedObjectLabel)
                                  .first,
                            )
                          ],
                        )
                ],
              )
            : const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 32,
                  ),
                  Text('Loading Predictions')
                ],
              )
      ],
    );
  }
}

class DescriptionsInner extends StatefulWidget {
  const DescriptionsInner({
    Key? key,
    required this.detected,
    required this.thisdescription,
  }) : super(key: key);

  final String detected;
  final Descriptions thisdescription;

  @override
  _DescriptionsInner createState() => _DescriptionsInner();
}

class _DescriptionsInner extends State<DescriptionsInner> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          widget.detected,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 16,
        ),
        const Text(
          'Cause',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(widget.thisdescription.cause),
        const SizedBox(
          height: 16,
        ),
        const Text(
          'How to Identify',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          widget.thisdescription.howtoidentify,
        ),
        const SizedBox(
          height: 16,
        ),
        const Text(
          'How to Manage',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(widget.thisdescription.howtomanage),
        const SizedBox(
          height: 16,
        ),
        const Text(
          'Why and where it occurs',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(widget.thisdescription.whyandwhereoccurs),
      ],
    ));
  }
}

class Results extends StatefulWidget {
  const Results({
    Key? key,
  }) : super(key: key);

  @override
  _Results createState() => _Results();
}

class _Results extends State<Results> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Results'));
  }
}

// class SettingsPage extends StatefulWidget {
//   const SettingsPage({
//     Key? key,
//   }) : super(key: key);

//   @override
//   _SettingsPage createState() => _SettingsPage();
// }

// class _SettingsPage extends State<SettingsPage> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Text('SettingsPage');
//   }
// }
