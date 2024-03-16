import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pict_frontend/config/app_constants.dart';

class AuthServices {
  static Future<String> signUp(
      firstName, lastName, email, mobileNo, password, role) async {
    try {
      var response = await http.post(
        Uri.parse("${AppConstants.IP}/account/signUp"),
        body: jsonEncode({
          "accountFirstName": firstName,
          "accountLastName": lastName,
          "accountEmail": email,
          "accountMobileNo": mobileNo,
          "accountPassword": password,
          "role": role,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print(response.statusCode);

      var result = jsonDecode(response.body);

      return result["message"];
    } catch (e) {
      print(e);
      return "Internal Server Error";
    }
  }
}
