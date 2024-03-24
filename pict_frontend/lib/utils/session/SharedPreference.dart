import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static Future<String> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    return "ok";
  }

  static Future<String> setSession(account) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (account["role"] == "user") {
      await prefs.setString('userId', account["_id"]);
      await prefs.setString(
          'name', account["userFirstName"] + " " + account["userLastName"]);
      await prefs.setString('email', account["userEmail"]);
      await prefs.setString('image', account["userImage"].toString());
      await prefs.setString('role', account["role"]);

      print(prefs.getString("userId"));
      print(prefs.getString("name"));
      print(prefs.getString("email"));
      print(prefs.getString("role"));
      print(prefs.getString("isloggedIn"));
    } else if (account["role"] == "recycler") {
      await prefs.setString('recyclerId', account["_id"]);
      await prefs.setString('name',
          account["recyclerFirstName"] + " " + account["recyclerLastName"]);
      await prefs.setString('email', account["recyclerEmail"]);
      await prefs.setString('image', account["recyclerImage"]);
      await prefs.setString('role', account["role"]);

      print(prefs.getString("recyclerId"));
      print(prefs.getString("name"));
      print(prefs.getString("email"));
      print(prefs.getString("role"));
      print(prefs.getString("isloggedIn"));
    } else if (account["role"] == "organizer") {
      await prefs.setString('organizerId', account["_id"]);
      await prefs.setString('name',
          account["organizerFirstName"] + " " + account["organizerLastName"]);
      await prefs.setString('email', account["organizerEmail"]);
      // await prefs.setString('image', account["organizerImage"]);
      await prefs.setString('role', account["role"]);

      print(prefs.getString("organizerId"));
      print(prefs.getString("name"));
      print(prefs.getString("email"));
      print(prefs.getString("role"));
      print(prefs.getString("isloggedIn"));
    }

    await prefs.setBool('isloggedIn', true);

    return "ok";
  }
}
