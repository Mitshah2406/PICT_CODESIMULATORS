// ignore_for_file: prefer_const_constructors

import 'package:yolo_realtime_plugin/yolo_realtime_plugin.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => YoloRealTimeViewExample(),
                  ),
                );
              },
              child: Text('START YOLO'),
            )
          ],
        ),
      ),
    );
  }
}

class YoloRealTimeViewExample extends StatefulWidget {
  const YoloRealTimeViewExample({super.key});

  @override
  State<YoloRealTimeViewExample> createState() =>
      _YoloRealTimeViewExampleState();
}

class _YoloRealTimeViewExampleState extends State<YoloRealTimeViewExample> {
  YoloRealtimeController? yoloController;

  @override
  void initState() {
    super.initState();

    yoloInit();
  }

  Future<void> yoloInit() async {
    yoloController = YoloRealtimeController(
      // common
      fullClasses: fullClasses,
      activeClasses: activeClasses,

      // android
      androidModelPath: 'assets/models/yoloNew.pt',
      androidModelWidth: 320,
      androidModelHeight: 320,
      androidConfThreshold: 0.5,
      androidIouThreshold: 0.5,

      // ios
      iOSModelPath: 'yolovNew.pt',
      iOSConfThreshold: 0.5,
    );

    try {
      await yoloController?.initialize();
    } catch (e) {
      print('ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (yoloController == null) {
      return Container();
    }

    return YoloRealTimeView(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      controller: yoloController!,
      drawBox: true,
      captureBox: (boxes) {
        // print(boxes);
      },
      captureImage: (data) async {
        // print('binary image: $data');

        /// Process and use the binary image as you wish.
        // imageToFile(data);
      },
    );
  }

  // Future<File?> imageToFile(Uint8List? image) async {
  //   File? file;
  //   if (image != null) {
  //     final tempDir = await getTemporaryDirectory();
  //     file = await File('${tempDir.path}/${DateTime.now()}.png').create();
  //     file.writeAsBytesSync(image);
  //
  //     print('File saved: ${file.path}');
  //   }
  //   return file;
  // }

  List<String> activeClasses = [
    'Glass bottle',
    'Meal carton',
    'Other carton',
    'Clear plastic bottle',
    'Paper bag',
    'Disposable plastic cup',
    'Broken glass',
    'Plastic utensils',
    'Glass jar',
    'Food waste',
    'Squeezable tube',
    'Spread tub',
    'Shoe',
    'Garbage bag',
    'Aluminium foil',
    'Six pack rings',
    'Foam cup',
    'Paper straw',
    'Corrugated carton',
    'Unlabeled litter',
    'Aluminium blister pack',
    'Battery',
    'Rope & strings',
    'Other plastic container',
    'Polypropylene bag',
    'Scrap metal',
    'Magazine paper',
    'Pizza box',
    'Plastic glooves',
    'Wrapping paper',
    'Carded blister pack',
    'Foam food container',
    'Tupperware',
    'Other plastic cup'
  ];
  List<String> fullClasses = [
    'Glass bottle',
    'Meal carton',
    'Other carton',
    'Clear plastic bottle',
    'Plastic bottle cap',
    'Drink can',
    'Food Can',
    'Other plastic bottle',
    'Pop tab',
    'Aerosol',
    'Glass cup',
    'Other plastic wrapper',
    'Styrofoam piece',
    'Plastic film',
    'Other plastic',
    'Drink carton',
    'Metal bottle cap',
    'Disposable food container',
    'Normal paper',
    'Paper cup',
    'Cigarette',
    'Single-use carrier bag',
    'Tissues',
    'Toilet tube',
    'Crisp packet',
    'Plastic lid',
    'Metal lid',
    'Egg carton',
    'Plastic straw',
    'Paper bag',
    'Disposable plastic cup',
    'Broken glass',
    'Plastic utensils',
    'Glass jar',
    'Food waste',
    'Squeezable tube',
    'Spread tub',
    'Shoe',
    'Garbage bag',
    'Aluminium foil',
    'Six pack rings',
    'Foam cup',
    'Paper straw',
    'Corrugated carton',
    'Unlabeled litter',
    'Aluminium blister pack',
    'Battery',
    'Rope & strings',
    'Other plastic container',
    'Polypropylene bag',
    'Scrap metal',
    'Magazine paper',
    'Pizza box',
    'Plastic glooves',
    'Wrapping paper',
    'Carded blister pack',
    'Foam food container',
    'Tupperware',
    'Other plastic cup'
  ];
}
