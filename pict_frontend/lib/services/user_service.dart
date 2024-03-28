import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:pict_frontend/utils/constants/app_constants.dart';

final userServiceProvider = Provider<UserServices>((ref) {
  return UserServices();
});

class UserServices {
  static Future<int> getCountOfUserRewards(userId) async {
    try {
      var response = await http.post(
        Uri.parse(
          "${AppConstants.IP}/user/getCountOfUserRewards",
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
}
