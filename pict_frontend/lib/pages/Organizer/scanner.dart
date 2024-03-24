// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:pict_frontend/models/Event.dart';
// import 'package:pict_frontend/pages/Organizer/organizer_home_screen.dart';
// import 'package:pict_frontend/services/event_service.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// class ScannerPage extends StatefulWidget {
//   const ScannerPage({super.key});

//   @override
//   State<ScannerPage> createState() => _ScannerPageState();
// }

// class _ScannerPageState extends State<ScannerPage> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   QRViewController? controller;
//   String scannerCode = '';
//   bool isRequestSent = false;

//   // @override
//   // void reassemble() {
//   //   super.reassemble();
//   //   if (Platform.isAndroid) {
//   //     controller!.pauseCamera();
//   //   } else if (Platform.isIOS) {
//   //     controller!.resumeCamera();
//   //   }
//   // }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Scan QR Code"),
//         actions: [
//           IconButton(
//             onPressed: () async {
//               await controller!.toggleFlash();
//             },
//             icon: const Icon(Icons.flashlight_on),
//           )
//         ],
//       ),
//       body: Stack(
//         children: [
//           QRView(
//             key: qrKey,
//             onQRViewCreated: _onQRViewCreated,
//           ),
//           Positioned.fill(
//             child: Container(
//               decoration: ShapeDecoration(
//                 shape: QrScannerOverlayShape(
//                   borderColor: Colors.white,
//                   borderRadius: 10,
//                   borderLength: 20,
//                   borderWidth: 5,
//                   cutOutSize: 350,
//                   // cutOutHeight: 200,
//                 ),
//               ),
//             ),
//           ),
//           // Expanded(
//           //     child: TextButton(
//           //         onPressed: () async {
//           //           await controller?.toggleFlash();
//           //         },
//           //         child: const Text("Toggle Flash"))),
//           // Center(
//           //   child: Text(
//           //     "Scanned Code: $scannerCode",
//           //     style: const TextStyle(
//           //       fontSize: 18,
//           //     ),
//           //   ),
//           // )
//         ],
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((event) async {
//       if (!isRequestSent) {
//         // Check if the request has not been sent yet
//         setState(() {
//           isRequestSent = true; // Mark the request as sent
//         });

//         print(event.code!);

//         List<String> ids = event.code!.split('-');
//         String userId = ids[0];
//         String eventId = ids[1];

//         try {
//           String res = await EventService.markPresent(userId, eventId);

//           print("Response from backend");
//           print(res);

//           if (res.isNotEmpty) {
//             showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return AlertDialog(
//                   title: const Text(
//                     "Output: ",
//                     style: TextStyle(
//                       color: Colors.red,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   content: Text(res),
//                   actions: [
//                     TextButton(
//                       onPressed: () async {
//                         Navigator.pushReplacement(context,
//                             MaterialPageRoute(builder: (context) {
//                           return const OrganizerHomePage();
//                         }));
//                       },
//                       child: const Text("Okay"),
//                     )
//                   ],
//                 );
//               },
//             );
//           }
//         } catch (e) {
//           print(e);
//         }
//       }
//     });
//   }
// }
