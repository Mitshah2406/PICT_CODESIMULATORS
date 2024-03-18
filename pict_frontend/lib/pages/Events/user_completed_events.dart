import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pict_frontend/providers/event_notifier.dart';
import 'package:pict_frontend/services/event_service.dart';
import 'package:pict_frontend/utils/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class UserCompletedEventsPage extends ConsumerStatefulWidget {
  const UserCompletedEventsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserCompletedEventsPageState();
}

class _UserCompletedEventsPageState
    extends ConsumerState<UserCompletedEventsPage> {
  String? _name;
  String? _id;

  Future<Null> getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString("name");
      _id = prefs.getString("userId");
    });
  }

  bool _isLoading = false;

  @override
  void initState() {
    _name = "";
    _id = "";
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_id.toString());
    final getCompletedEventsOfUsers =
        ref.watch(getUserCompletedEvents(_id.toString()));
    // print(getCompletedEventsOfUsers.value?.map((e) => print(e.eventName)));

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Completed Events"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // const Text("Completed Events"),
          getCompletedEventsOfUsers.when(
            data: (events) {
              return ListView.builder(
                padding: const EdgeInsets.all(10),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];

                  return Card(
                    child: Center(
                      child: ListTile(
                        titleAlignment: ListTileTitleAlignment.center,
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            child: FadeInImage.memoryNetwork(
                              fit: BoxFit.cover,
                              width: 80,
                              height: 50,
                              placeholder: kTransparentImage,
                              image: event.eventPoster == null
                                  ? "${AppConstants.IP}/poster/fallback-poster.png"
                                  : "${AppConstants.IP}/poster/${event.eventPoster}",
                            ),
                          ),
                        ),
                        title: Text(
                          event.eventName!,
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          maxLines: 2,
                          event.eventDescription!,
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        trailing: TextButton(
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });

                            String res = await EventService.generateCertificate(
                                _id!, event.id!);

                            print(res);

                            if (res.isNotEmpty) {
                              await _createPDF(res);
                            }

                            setState(() {
                              _isLoading = false;
                            });
                          },
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : const Text("View"),
                        ),
                        isThreeLine: true,
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stackTrace) => Text('Error: $error'),
          )
        ],
      ),
    );
  }

  String extractName(String filePath) {
    // Find the start and end positions of the name within the file path
    final startIndex = filePath.indexOf('(');
    final endIndex = filePath.lastIndexOf(')');

    if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
      // Extract the substring containing the name and remove leading/trailing whitespace
      final name = filePath.substring(startIndex + 1, endIndex).trim();
      return name;
    } else {
      // If the file path format is unexpected, return the original file path
      return filePath;
    }
  }

  Future<void> _createPDF(fileName) async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();

    print("Hello Image");
    print(fileName);
    page.graphics.drawImage(
      PdfBitmap(
        await _readImageData(fileName),
      ),
      const Rect.fromLTWH(0, 0, 500, 500),
    );

    List<int> bytes = await document.save();
    document.dispose();

    final name = extractName(fileName);

    saveAndLaunchFile(bytes, "${name}_certificate.pdf");
  }

  Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    final path = (await getExternalStorageDirectory())?.path;
    final file = File('$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/$fileName');
  }

  Future<Uint8List> _readImageData(String name) async {
    print("Nameeeee");
    print(name);

    final response =
        await http.get(Uri.parse('${AppConstants.IP}/certificates$name'));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image: ${response.statusCode}');
    }
  }
}
