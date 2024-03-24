import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pict_frontend/utils/constants/app_constants.dart';

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

  static Future editProfile(
      userFirstName, userLastName, userEmail, userImage) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${AppConstants.IP}/editProfile"),
      );

      request.fields.addAll({
        "userFirstName": userFirstName,
        "userLastName": userLastName,
        "userEmail": userEmail,
      });

      if (userImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'userImage',
            userImage,
          ),
        );
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      var result = jsonDecode(responseData);

      print(result);

      return result;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
