import 'package:geolocator/geolocator.dart';
import 'package:pict_frontend/utils/logging/logger.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeolocationService {
  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  static Future<String> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return Future.value('Location permissions are granted');
  }

  static Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    LoggerHelper.info('Location: ${position.latitude}, ${position.longitude}');
    return position;
  }

  static Future<Placemark> reverseGeocode(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    return placemarks[0];
  }

  static void storeLocation() async {
    Position position = await getCurrentLocation();
    Placemark place = await reverseGeocode(position);
    LoggerHelper.info('Location: ${position.latitude}, ${position.longitude}');
    LoggerHelper.info('Address: $place');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> location = {
      "latitude": position.latitude.toString(),
      "longitude": position.longitude.toString(),
      "address":
          "${place.name} ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country} ${place.postalCode}"
    };
    prefs.setString("location", location.toString());
    prefs.setString("cityName", "${place.locality} ${place.subLocality!}");
  }

  static Future<Map<String, String>> getLocationFromSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? location = prefs.getString("location");
    if (location != null) {
      Map<String, String> loc = {
        "latitude": location.split(",")[0].split(":")[1],
        "longitude": location.split(",")[1].split(":")[1],
        "address": location.split(",")[2].split(":")[1]
      };

      LoggerHelper.info("From Service File ${loc.toString()}");
      return loc;
    } else {
      return {};
    }
  }
}
