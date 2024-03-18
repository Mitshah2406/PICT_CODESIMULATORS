import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pict_frontend/utils/geolocation/geolocation_service.dart';
import 'package:pict_frontend/utils/logging/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationEg extends StatefulWidget {
  const LocationEg({super.key});

  @override
  State<LocationEg> createState() => _LocationEgState();
}

class _LocationEgState extends State<LocationEg> {
  Placemark? _currentAddress;
  Position? _currentPosition;
  Future<void> getLocation() async {
    GeolocationService.storeLocation();
    GeolocationService.getLocationFromSession();
    // GeolocationService.determinePosition();
    Position p = await GeolocationService.getCurrentLocation();
    Placemark place = await GeolocationService.reverseGeocode(p);
    setState(() {
      _currentPosition = p;
      _currentAddress = place;
    });

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // LoggerHelper.info("Session info: ${prefs.getString("location")}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Location Example"),
        ),
        body: Column(
          children: [
            Text('LAT: ${_currentPosition?.latitude ?? ""}'),
            Text('LNG: ${_currentPosition?.longitude ?? ""}'),
            Text('ADDRESS: ${_currentAddress ?? ""}'),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                getLocation();
              },
              child: const Text("Get Location"),
            )
          ],
        ));
  }
}
