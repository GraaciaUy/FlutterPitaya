import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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
                label: 'Settings',
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
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseuser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: MultiProvider(
        providers: [
          StreamProvider<List<Descriptions>>.value(
            value: DatabaseService(
              uid: firebaseuser!.uid,
            ).alldescriptions,
            initialData: [],
          ),
        ],
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PestCategory(),
                SizedBox(
                  height: 16,
                ),
                DiseaseCategory(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          image = await picker
              .pickImage(source: ImageSource.gallery)
              .then((value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetectionPage(
                              thisImage: value!.path,
                            )),
                  ));
        },
        child: const Image(
          image: AssetImage(
              'asset/UploadPhoto.png'), // Replace with your image path
        ),
      ),
    );
  }
}

class DetectionPage extends StatefulWidget {
  const DetectionPage({
    Key? key,
    required this.thisImage,
  }) : super(key: key);

  final String thisImage;

  @override
  _DetectionPage createState() => _DetectionPage();
}

class _DetectionPage extends State<DetectionPage> {
  @override
  void initState() {
    super.initState();
    _startDetection();
  }

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

  bool isDetecting = true;

  String detectedObjectLabel = "";
  String detectedConfidenc = "";

  bool hasDetected = false;

  bool hasPickedOptions = false;

  _startDetection() async {
    inputImage = InputImage.fromFilePath(widget.thisImage);

    final modelPath = await getModelPath('asset/ml/model1.tflite');
    final options = LocalObjectDetectorOptions(
      mode: DetectionMode.single,
      modelPath: modelPath,
      classifyObjects: true,
      multipleObjects: false,
    );
    final objectDetector = ObjectDetector(options: options);

    final objects = await objectDetector.processImage(inputImage);

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
  }

  @override
  Widget build(BuildContext context) {
    final firebaseuser = FirebaseAuth.instance.currentUser;

    back() {
      Navigator.pop(context);
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: 1000,
          child: MultiProvider(
            providers: [
              StreamProvider<List<Descriptions>>.value(
                value: DatabaseService(
                  uid: firebaseuser!.uid,
                ).alldescriptions,
                initialData: [],
              ),
            ],
            child: Container(
                padding: const EdgeInsets.only(left: 16, right: 16),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: isDetecting
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(
                            height: 32,
                          ),
                          Text('Loading Predictions'),
                          const SizedBox(
                            height: 32,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Re-run Prediction')),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text('Prediction taking too long?')
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.arrow_back)),
                              SizedBox(
                                width: 24,
                              ),
                              Text('Prediction Result',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32)),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: 250,
                            child: Image.file(File(widget.thisImage)),
                          ),
                          DetectionPageInner(
                            detected: detectedObjectLabel,
                            uid: firebaseuser.uid,
                            imgpath: widget.thisImage,
                          ),
                          // Text(detectedObjectLabel)
                        ],
                      )),
          ),
        ),
      ),
    );
  }
}

class DetectionPageInner extends StatefulWidget {
  const DetectionPageInner({
    Key? key,
    required this.detected,
    required this.uid,
    required this.imgpath,
  }) : super(key: key);

  final String detected;
  final String uid;
  final String imgpath;

  @override
  _DetectionPageInner createState() => _DetectionPageInner();
}

class _DetectionPageInner extends State<DetectionPageInner> {
  @override
  void initState() {
    super.initState();
  }

  String fileUrlFromStorage = "";

  @override
  Widget build(BuildContext context) {
    final descriptions = Provider.of<List<Descriptions>>(context);
    return descriptions.isNotEmpty
        ? Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  descriptions
                      .where((element) => element.name == widget.detected)
                      .first
                      .uiname,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 32),
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
                Text(descriptions
                    .where((element) => element.name == widget.detected)
                    .first
                    .cause),
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
                Text(descriptions
                    .where((element) => element.name == widget.detected)
                    .first
                    .howtoidentify),
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
                Text(descriptions
                    .where((element) => element.name == widget.detected)
                    .first
                    .howtomanage),
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
                Text(descriptions
                    .where((element) => element.name == widget.detected)
                    .first
                    .whyandwhereoccurs),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 56,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF90EE90),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(4), // Adjust the radius here
                      ),
                    ),
                    onPressed: () async {
                      firebase_storage.Reference ref = firebase_storage
                          .FirebaseStorage.instance
                          .ref()
                          .child('/${widget.uid}')
                          .child(
                              '${generateRandomString(10) + widget.uid}.png');

                      firebase_storage.UploadTask uploadTask;

                      uploadTask = ref.putFile(File(widget.imgpath));

                      await uploadTask;

                      await ref.getDownloadURL().then((fileUrl) {
                        setState(() {
                          fileUrlFromStorage = fileUrl;
                          print(fileUrlFromStorage);
                        });
                      });

                      DatabaseService(uid: widget.uid)
                          .insertResult(
                              widget.uid, fileUrlFromStorage, widget.detected)
                          .then((value) => Navigator.pop(context));
                    },
                    child: Text(
                      'Save Results',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 56,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container();
  }

  String generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(
        List.generate(len, (index) => r.nextInt(33) + 89));
  }
}

class DetectionPageDescriptionBuilder extends StatefulWidget {
  const DetectionPageDescriptionBuilder({
    Key? key,
    required this.thisdesc,
  }) : super(key: key);

  final Descriptions thisdesc;

  @override
  _DetectionPageDescriptionBuilder createState() =>
      _DetectionPageDescriptionBuilder();
}

class _DetectionPageDescriptionBuilder
    extends State<DetectionPageDescriptionBuilder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('DetectionPageDescriptionBuilder'));
  }
}

class DiseaseCategory extends StatefulWidget {
  const DiseaseCategory({
    Key? key,
  }) : super(key: key);

  @override
  _DiseaseCategory createState() => _DiseaseCategory();
}

class _DiseaseCategory extends State<DiseaseCategory> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final descriptions = Provider.of<List<Descriptions>>(context);

    return descriptions.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: const Text(
                  'Disease',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              PestCardsRow(
                  descriptions: descriptions
                      .where((obj) => obj.category == 'disease')
                      .toList())
            ],
          )
        : Container();
  }
}

class PestCategory extends StatefulWidget {
  const PestCategory({
    Key? key,
  }) : super(key: key);

  @override
  _PestCategory createState() => _PestCategory();
}

class _PestCategory extends State<PestCategory> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final descriptions = Provider.of<List<Descriptions>>(context);

    return descriptions.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: const Text(
                  'Pest',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              DiseaseCardsRow(
                  descriptions: descriptions
                      .where((obj) => obj.category == 'pests')
                      .toList())
            ],
          )
        : Container();
  }
}

class DiseaseCardsRow extends StatefulWidget {
  const DiseaseCardsRow({
    Key? key,
    required this.descriptions,
  }) : super(key: key);

  final List<Descriptions> descriptions;

  @override
  _DiseaseCardsRow createState() => _DiseaseCardsRow();
}

class _DiseaseCardsRow extends State<DiseaseCardsRow> {
  @override
  void initState() {
    super.initState();
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext ctx, int index) {
            return Padding(
              padding: const EdgeInsets.only(left: 16),
              child: GestureDetector(
                onTap: () {
                  selectedIndex = index;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PreviewCategory(
                              desc: widget.descriptions[selectedIndex],
                            )),
                  );
                },
                child: Container(
                  height: 250,
                  width: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(widget
                          .descriptions[index]
                          .photo), // Use CachedNetworkImageProvider
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    height: 250,
                    width: 200,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(0, 144, 238, 144),
                          Color.fromARGB(255, 144, 238, 144),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.descriptions[index].uiname,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: widget.descriptions.length),
    );
  }
}

class PestCardsRow extends StatefulWidget {
  const PestCardsRow({
    Key? key,
    required this.descriptions,
  }) : super(key: key);

  final List<Descriptions> descriptions;

  @override
  _PestCardsRow createState() => _PestCardsRow();
}

class _PestCardsRow extends State<PestCardsRow> {
  @override
  void initState() {
    super.initState();
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext ctx, int index) {
            return Padding(
              padding: const EdgeInsets.only(left: 16),
              child: GestureDetector(
                onTap: () {
                  selectedIndex = index;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PreviewCategory(
                              desc: widget.descriptions[selectedIndex],
                            )),
                  );
                },
                child: Container(
                  height: 250,
                  width: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(widget
                          .descriptions[index]
                          .photo), // Use CachedNetworkImageProvider
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    height: 250,
                    width: 200,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(0, 144, 238, 144),
                          Color.fromARGB(255, 144, 238, 144),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.descriptions[index].uiname,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: widget.descriptions.length),
    );
  }
}

class PreviewCategory extends StatefulWidget {
  const PreviewCategory({
    Key? key,
    required this.desc,
  }) : super(key: key);

  final Descriptions desc;

  @override
  _PreviewCategory createState() => _PreviewCategory();
}

class _PreviewCategory extends State<PreviewCategory> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back)),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    widget.desc.uiname,
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        widget.desc.photo), // Use CachedNetworkImageProvider
                    fit: BoxFit.cover,
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                height: 250,
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
              Text(widget.desc.cause),
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
                widget.desc.howtoidentify,
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
              Text(widget.desc.howtomanage),
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
              Text(widget.desc.whyandwhereoccurs),
            ],
          ),
        )),
      ),
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
          style: const TextStyle(fontWeight: FontWeight.bold),
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
    final firebaseuser = FirebaseAuth.instance.currentUser;
    return Scaffold(
        body: SingleChildScrollView(
      child: MultiProvider(providers: [
        StreamProvider<List<Descriptions>>.value(
          value: DatabaseService(
            uid: firebaseuser!.uid,
          ).alldescriptions,
          initialData: [],
        ),
        StreamProvider<List<ResultsData>>.value(
          value: DatabaseService(
            uid: firebaseuser.uid,
          ).getuserResults,
          initialData: [],
        ),
      ], child: ResultsInner()),
    ));
  }
}

class ResultsInner extends StatefulWidget {
  const ResultsInner({
    Key? key,
  }) : super(key: key);

  @override
  _ResultsInner createState() => _ResultsInner();
}

class _ResultsInner extends State<ResultsInner> {
  @override
  void initState() {
    super.initState();
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final resultsData = Provider.of<List<ResultsData>>(context);
    final descriptions = Provider.of<List<Descriptions>>(context);

    return descriptions.isNotEmpty && resultsData.isNotEmpty
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext ctx, int index) {
                  return Padding(
                      padding: const EdgeInsets.only(left: 4, right: 4),
                      child: SizedBox(
                        child: GestureDetector(
                            onTap: () {
                              selectedIndex = index;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PreviewResult(
                                          desc: descriptions
                                              .where((element) =>
                                                  element.name ==
                                                  resultsData[selectedIndex]
                                                      .detected)
                                              .first,
                                          res: resultsData[selectedIndex],
                                        )),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 72,
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: 64,
                                      height: 64,
                                      child: CachedNetworkImage(
                                          imageUrl: resultsData[index].photo)),
                                  const SizedBox(
                                    width: 32,
                                  ),
                                  Text(resultsData[index].detected),
                                ],
                              ),
                            )),
                      ));
                },
                itemCount: resultsData.length),
          )
        : Container();
  }
}

class PreviewResult extends StatefulWidget {
  const PreviewResult({
    Key? key,
    required this.desc,
    required this.res,
  }) : super(key: key);

  final Descriptions desc;
  final ResultsData res;

  @override
  _PreviewResult createState() => _PreviewResult();
}

class _PreviewResult extends State<PreviewResult> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back)),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    widget.desc.uiname,
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        widget.res.photo), // Use CachedNetworkImageProvider
                    fit: BoxFit.cover,
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                height: 250,
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
              Text(widget.desc.cause),
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
                widget.desc.howtoidentify,
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
              Text(widget.desc.howtomanage),
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
              Text(widget.desc.whyandwhereoccurs),
            ],
          ),
        )),
      ),
    );
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
