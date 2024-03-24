import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pict_frontend/models/Report.dart';
import 'package:pict_frontend/services/report_service.dart';

class ReportNotifier extends StateNotifier<List<Report>> {
  ReportNotifier() : super(const []);

  Future<bool> addReport(Report report) async {
    // Send the report
    print("Report Notifier:");
    print(report);
    final response = await ReportService.addReport(report);

    if (response == "ok") {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Report>> getAllUserReports(String userId, String filter) async {
    final response = await ReportService.getAllUserReports(userId, filter);

    return response;
  }

  Future<List<Report>> getSearchReport(String query) async {
    final response = await ReportService.getSearchReport(query);

    print(response);

    return response;
  }

  Future<int> getCountOfAllUserReports(String userId) async {
    final response = await ReportService.getCountOfUserReports(userId);

    return response;
  }

  // Future<List<Report>> getAllUserPendingReports(String userId) async {
  //   final response = await ReportService.getAllUserPendingReports(userId);

  //   return response;
  // }

  // Future<List<Report>> getAllUserResolvedReports(String userId) async {
  //   final response = await ReportService.getAllUserResolvedReports(userId);

  //   return response;
  // }

  // Future<List<Report>> getAllUserRejectedReports(String userId) async {
  //   final response = await ReportService.getAllUserRejectedReports(userId);

  //   return response;
  // }
}

final reportNotifier = StateNotifierProvider<ReportNotifier, List<Report>>(
  (ref) => ReportNotifier(),
);
