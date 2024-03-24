import 'dart:convert';

// import 'package:favourite_places/models/place.dart';
// import 'package:favourite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:pict_frontend/models/Report.dart';
import 'package:pict_frontend/utils/geolocation/geolocation_service.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});
  final void Function(Location pickedLocation) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  Location? location;
  var findingLocation = false;

  void _getCurrentLocation() async {
    setState(() {
      findingLocation = true;
    });

    await GeolocationService.determinePosition();
    Position locationData = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final double lat = locationData.latitude;
    final double lng = locationData.longitude;

    final address = await GeolocationService.reverseGeocode(locationData);
    print("Addresss From Reverse Geocode");
    print(address);

    final formattedAddress = [
      if (address.name != null) address.name,
      // if (address.street != null) address.street,
      if (address.subLocality != null) address.subLocality,
      if (address.locality != null) address.locality,
      if (address.administrativeArea != null) address.administrativeArea,
      if (address.country != null) address.country,
      if (address.postalCode != null) address.postalCode,
    ].where((part) => part != null).join(', ');

    setState(() {
      location = Location(
        lat: lat,
        lon: lng,
        formattedAddress: formattedAddress,
      );
      findingLocation = false;
    });

    widget.onSelectLocation(location!);
  }

  String get locationImage {
    if (location == null) {
      return '';
    }

    final lat = location!.lat;
    final lng = location!.lon;

    return "https://maps.googleapis.com/maps/api/staticmap?center$lat,$lng=zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:I%7C$lat,$lng&key=AIzaSyBw7fIXJz5sA9IEcczMJ9FIzK91jvFIsno";
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      "No Choosen Location",
      style: TextStyle(
        color: Theme.of(context).colorScheme.onBackground,
      ),
    );

    if (findingLocation) {
      previewContent = Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }

    if (location != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          width: double.infinity,
          height: 250,
          child: previewContent,
        ),
        const SizedBox(
          height: 10,
        ),
        location?.formattedAddress != null
            ? RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      // letterSpacing: .5,
                    ),
                  ),
                  children: [
                    const TextSpan(
                      text: 'Your Address: ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: location?.formattedAddress.toString(),
                      style: const TextStyle(color: Colors.black),
                    )
                  ],
                ),
              )
            : Text(""),
        const SizedBox(
          height: 10,
        ),
        TextButton.icon(
          onPressed: _getCurrentLocation,
          icon: const Icon(Icons.location_on_outlined),
          label: const Text("Get Current Location"),
        )
      ],
    );
  }
}
