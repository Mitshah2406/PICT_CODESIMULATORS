import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pict_frontend/models/Report.dart';
import 'package:http/http.dart' as http;
import 'package:pict_frontend/utils/constants/app_constants.dart';

final reportServiceProvider = Provider<Report>((ref) {
  return Report();
});

class ReportService {
  static Future<String> addReport(Report report) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${AppConstants.IP}/report/addReport"),
      );

      request.fields.addAll({
        "uploaderId": report.uploaderId!,
        "uploaderName": report.uploaderName!,
        "uploaderEmail": report.uploaderEmail!,
        "description": report.description!,
        "lat": report.location!.lat.toString(),
        "lon": report.location!.lon.toString(),
        "formattedAddress": report.location!.formattedAddress.toString(),
      });

      if (report.reportAttachment != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'reportAttachment',
            report.reportAttachment!,
          ),
        );
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      var result = jsonDecode(responseData)["result"];

      print(result);

      return result;
    } catch (e) {
      print("Error occurred: $e");
      throw Exception("Failed to Add report");
    }
  }

  static Future<List<Report>> getAllUserReports(userId, filter) async {
    try {
      var response = await http.post(
        Uri.parse(
          "${AppConstants.IP}/report/getAllUserReports",
        ),
        body: jsonEncode({"userId": userId, "filter": filter}),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      var result = jsonDecode(response.body)["result"];

      List<Report> reports = [];

      for (var reportJson in result) {
        Report report = Report.fromJson(reportJson);
        reports.add(report);
      }

      return reports;
    } catch (e) {
      print(e);
      throw Exception("Failed to get User reports");
    }
  }

  static Future<int> getCountOfUserReports(userId) async {
    try {
      var response = await http.post(
        Uri.parse(
          "${AppConstants.IP}/report/getCountOfAllUserReports",
        ),
        body: jsonEncode({
          "userId": userId,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      int result = jsonDecode(response.body)["result"];

      print(result);

      return result;
    } catch (e) {
      print(e);
      throw Exception("Failed to count of user reports");
    }
  }

  // static Future<List<Report>> getAllUserPendingReports(userId) async {
  //   try {
  //     var response = await http.post(
  //       Uri.parse(
  //         "${AppConstants.IP}/report/getAllUserPendingReports",
  //       ),
  //       body: jsonEncode({"userId": userId}),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //     );

  //     var result = jsonDecode(response.body)["result"];

  //     List<Report> reports = [];

  //     for (var reportJson in result) {
  //       Report report = Report.fromJson(reportJson);
  //       reports.add(report);
  //     }

  //     return reports;
  //   } catch (e) {
  //     print(e);
  //     throw Exception("Failed to get User reports");
  //   }
  // }

  // static Future<List<Report>> getAllUserResolvedReports(userId) async {
  //   try {
  //     var response = await http.post(
  //       Uri.parse(
  //         "${AppConstants.IP}/report/getAllUserResolvedReports",
  //       ),
  //       body: jsonEncode({"userId": userId}),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //     );

  //     var result = jsonDecode(response.body)["result"];

  //     List<Report> reports = [];

  //     for (var reportJson in result) {
  //       Report report = Report.fromJson(reportJson);
  //       reports.add(report);
  //     }

  //     return reports;
  //   } catch (e) {
  //     print(e);
  //     throw Exception("Failed to get User reports");
  //   }
  // }

  // static Future<List<Report>> getAllUserRejectedReports(userId) async {
  //   try {
  //     var response = await http.post(
  //       Uri.parse(
  //         "${AppConstants.IP}/report/getAllUserRejectedReports",
  //       ),
  //       body: jsonEncode({"userId": userId}),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //     );

  //     var result = jsonDecode(response.body)["result"];

  //     List<Report> reports = [];

  //     for (var reportJson in result) {
  //       Report report = Report.fromJson(reportJson);
  //       reports.add(report);
  //     }

  //     return reports;
  //   } catch (e) {
  //     print(e);
  //     throw Exception("Failed to get User reports");
  //   }
  // }
}
