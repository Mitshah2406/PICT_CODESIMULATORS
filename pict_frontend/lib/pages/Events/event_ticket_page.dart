import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:pict_frontend/models/Event.dart';
import 'package:pict_frontend/utils/constants/app_colors.dart';
import 'package:pict_frontend/utils/constants/app_constants.dart';
import 'package:pict_frontend/utils/logging/logger.dart';
import 'package:pict_frontend/widgets/dotted_line.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class EventTicketPage extends StatefulWidget {
  const EventTicketPage(
      {super.key,
      required this.event,
      required this.userImage,
      required this.userId});
  final Event event;
  final String userImage;
  final String userId;
  @override
  State<EventTicketPage> createState() => _EventTicketPageState();
}

class _EventTicketPageState extends State<EventTicketPage> {
  String? _name;
  String? _id;
  String? _userImage;

  Future<Null> getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString("name");
      _id = prefs.getString("userId");
      _userImage = prefs.getString("image");
    });
    LoggerHelper.info(_name!);
  }

  @override
  void initState() {
    _id = "";
    _name = "";
    _userImage = "";
    getSession();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Event event = widget.event;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            event.eventName.toString(),
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
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              width: double.infinity,
              height: 600,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? TColors.white
                    : TColors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: ClipOval(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: event.eventPoster == null
                          ? Image.network(
                              fit: BoxFit.cover,
                              "${AppConstants.IP}/poster/fallback-poster.png",
                            )
                          : Image.network(
                              "${AppConstants.IP}/poster/${event.eventPoster}",
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(event.eventName.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                              fontWeight: FontWeight.w600,
                              color: TColors.primaryGreen)),
                  Text(
                    "${event.eventStartDate!.day} ${AppConstants.months[event.eventStartDate!.month - 1]}, ${event.eventAddress}, ${event.eventCity} ",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.grey, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: TColors.darkGrey),
                            ),
                            Text(
                              _name.toString() == 'null'
                                  ? "Name"
                                  : _name.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: TColors.black),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Date",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: TColors.darkGrey),
                            ),
                            Text(
                              "${AppConstants.months[event.eventStartDate!.month - 1]} ${event.eventStartDate!.day} ${event.eventStartDate!.year}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: TColors.black),
                            ),
                          ],
                        ),
                        // const Spacer(),
                        const SizedBox(
                          width: 50,
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ticket Number",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: TColors.darkGrey),
                              ),
                              Text(
                                event.id.toString(),
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: TColors.black),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Time",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: TColors.darkGrey),
                              ),
                              Text(
                                "${event.eventStartTime}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: TColors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Color(0xffE5D8FF),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Flexible(
                        child: DottedLine(),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 20,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Color(0xffE5D8FF),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            bottomLeft: Radius.circular(50),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 80,
                    child: SfBarcodeGenerator(
                      barColor: TColors.black,
                      value: _id,
                      showValue: true,
                      textStyle: const TextStyle(
                          color: TColors.primaryGreen,
                          fontWeight: FontWeight.normal,
                          fontSize: 12),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "Scan the barcode at entry gate.",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: TColors.darkerGrey, fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
