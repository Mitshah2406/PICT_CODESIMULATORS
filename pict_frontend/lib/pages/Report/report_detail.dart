import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pict_frontend/models/Report.dart';
import 'package:pict_frontend/utils/constants/app_colors.dart';
import 'package:pict_frontend/utils/constants/app_constants.dart';
import 'package:pict_frontend/widgets/timeline.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ReportDetail extends StatefulWidget {
  const ReportDetail({super.key, required this.report});
  final Report report;

  @override
  State<ReportDetail> createState() => _ReportDetailState();
}

class _ReportDetailState extends State<ReportDetail> {
  @override
  Widget build(BuildContext context) {
    final Report report = widget.report;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Report Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Container(
          height: 250,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black12,
            ),
            color: TColors.reportDetailPage,
            borderRadius: BorderRadius.circular(20), // Set border radius here
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${report.createdOn!.day} ${AppConstants.months[report.createdOn!.month - 1]}, ${report.createdOn!.year}",
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: TColors.black,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  report.location?.formattedAddress != null
                      ? report.location!.formattedAddress.toString()
                      : "",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: TColors.black),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: MyTimeLineTile(
                        isFirst: true,
                        isLast: false,
                        isPast: true,
                        status: "Reported",
                      ),
                    ),
                    Expanded(
                      child: MyTimeLineTile(
                        isFirst: false,
                        isLast: false,
                        isPast: report.reportStatus == "pending" ||
                            report.reportStatus == "rejected" ||
                            report.reportStatus == "resolved",
                        status: "Waiting",
                      ),
                    ),
                    Expanded(
                      child: MyTimeLineTile(
                        isFirst: false,
                        isLast: true,
                        isPast: report.reportStatus == "rejected" ||
                            report.reportStatus == "resolved",
                        status: "Viewed",
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Hero(
                      tag: report.id!,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                        child: SizedBox(
                          width: 180,
                          height: 180,
                          child: ClipOval(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Image.network(
                              "${AppConstants.IP}/reportAttachments/${report.reportAttachment}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      report.description != null
                          ? report.description.toString()
                          : "",
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                fontWeight: FontWeight.w400,
                                color: TColors.black,
                              ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
