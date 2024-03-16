import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pict_frontend/config/app_constants.dart';

class AuthServices {
  static Future signUp(
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

      print(result);

      return result;
    } catch (e) {
      print(e);
      return "Internal Server Error";
    }
  }

  static Future signIn(email, password) async {
    try {
      var response = await http.post(
        Uri.parse("${AppConstants.IP}/account/signIn"),
        body: jsonEncode({
          "accountEmail": email,
          "accountPassword": password,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print(response.statusCode);

      var result = jsonDecode(response.body);

      print(result);

      return result;
    } catch (e) {
      print(e);
      return "Internal Server Error";
    }
  }
}
