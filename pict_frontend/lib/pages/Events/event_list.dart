import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pict_frontend/pages/Events/event_details.dart';
// import 'package:pict_frontend/pages/Events/events_home.dart';
import 'package:pict_frontend/utils/constants/app_colors.dart';
import 'package:pict_frontend/utils/constants/app_constants.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:http/http.dart' as http;

import '../../../models/Event.dart';
import '../../../services/event_service.dart';

class EventList extends StatefulWidget {
  const EventList(
      {super.key,
      required this.userId,
      required this.name,
      required this.events,
      required this.userImage});
  final String userId;

  final String name;
  final List<Event> events;
  final String userImage;

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name.toString(),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: widget.userImage.isNotEmpty
                ? CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: SizedBox(
                      width: 180,
                      height: 180,
                      child: ClipOval(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: widget.userImage == "null"
                            ? Image.asset(
                                "assets/images/villager.png",
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                "${AppConstants.IP}/userImages/${widget.userImage}",
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  )
                : const CircularProgressIndicator(),
          )
        ],
      ),
      body: widget.events.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "There are no events. Hurry up and participate!",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.black),
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: TColors.primaryGreen,
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 15,
                  //       vertical: 10,
                  //     ),
                  //   ),
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => const EventsHomePage(),
                  //       ),
                  //     );
                  //   },
                  //   child: const Text("Browse Events"),
                  // )
                ],
              ),
            )
          : ListView.builder(
              itemCount: widget.events.length,
              itemBuilder: (context, index) {
                Event event = widget.events[index];
                Color color = index % 3 == 0
                    ? TColors.primaryYellow
                    : index % 3 == 1
                        ? TColors.accentGreen
                        : TColors.accentYellow;

                print("object");
                print(widget.events.length);

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => EventDetailsPage(
                            event: event,
                            userId: widget.userId,
                            userImage: widget.userImage,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.eventName.toString(),
                                    softWrap: true,
                                    // textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  event.volunteers!.isNotEmpty
                                      ? Text(
                                          event.volunteers!.length == 1
                                              ? "${event.volunteers!.length} Volunteer"
                                              : "${event.volunteers!.length} Volunteers",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                        )
                                      : const SizedBox.shrink(),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${AppConstants.months[event.eventStartDate!.month - 1]} ${event.eventStartDate!.day}"
                                        .toUpperCase(),
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  widget.name.contains("Completed")
                                      ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                TColors.primaryGreen,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                              vertical: 10,
                                            ),
                                          ),
                                          onPressed: () async {
                                            setState(() {
                                              _isLoading = true;
                                            });

                                            String res = await EventService
                                                .generateCertificate(
                                              widget.userId,
                                              event.id!,
                                            );

                                            print(res);

                                            if (res.isNotEmpty) {
                                              await _createPDF(res);
                                              setState(() {
                                                _isLoading = false;
                                              });
                                            }
                                          },
                                          child: _isLoading
                                              ? const CircularProgressIndicator()
                                              : Text(
                                                  "View Certificate",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                        color: TColors.white,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                ),
                                        )
                                      : ElevatedButton(
                                          onPressed: () {
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) =>
                                            //         const EventDetailsPage(),
                                            //   ),
                                            // );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                          ),
                                          child: Text(
                                            "Explore now",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                  color: TColors.white,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            Hero(
                              tag: event.id!,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 60,
                                child: SizedBox(
                                  width: 180,
                                  height: 180,
                                  child: ClipOval(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: event.eventPoster == null
                                        ? Image.network(
                                            "${AppConstants.IP}/poster/fallback-poster.png",
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            "${AppConstants.IP}/poster/${event.eventPoster}",
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
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

    // Load the image
    final imageBytes = await _readImageData(fileName);
    final PdfBitmap pdfImage = PdfBitmap(imageBytes);

    // Calculate image dimensions
    final double imageWidth = pdfImage.width.toDouble();
    final double imageHeight = pdfImage.height.toDouble();

    // Calculate page dimensions
    final double pageWidth = page.getClientSize().width;
    final double pageHeight = page.getClientSize().height;

    // Calculate scale factors to fit the image within the page
    final double scaleX = pageWidth / imageWidth;
    final double scaleY = pageHeight / imageHeight;
    final double scaleFactor = scaleX < scaleY ? scaleX : scaleY;

    // Calculate dimensions for the resized image
    final double resizedWidth = imageWidth * scaleFactor;
    final double resizedHeight = imageHeight * scaleFactor;

    // Calculate position to center the resized image on the page
    final double offsetX = (pageWidth - resizedWidth) / 2;
    final double offsetY = (pageHeight - resizedHeight) / 2;

    // Draw the resized image in the center of the page
    page.graphics.drawImage(
      pdfImage,
      Rect.fromLTWH(offsetX, offsetY, resizedWidth, resizedHeight),
    );

    // Save the document
    List<int> bytes = await document.save();
    document.dispose();

    // Save and launch the file
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
