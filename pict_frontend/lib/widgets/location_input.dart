import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pict_frontend/models/Report.dart';
import 'package:pict_frontend/utils/constants/app_colors.dart';
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
        lat: lat.toString(),
        lon: lng.toString(),
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
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: TColors.primaryGreen,
          ),
    );

    if (findingLocation) {
      previewContent = const Center(
        child: CircularProgressIndicator(
          color: TColors.black,
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

    print("Hello");
    print(location?.formattedAddress.toString());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 5,
        ),
        Text(
          location?.formattedAddress.toString() ??
              "Your location will appear here...",
          maxLines: null,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: TColors.black),
          textAlign: TextAlign.start,
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          width: double.infinity,
          height: 130,
          child: previewContent,
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: ElevatedButton.icon(
            onPressed: _getCurrentLocation,
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.primaryGreen,
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
            ),
            label: Text(
              "Get Location",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: TColors.white,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            icon: const Icon(Icons.location_on_outlined),
          ),
        ),
      ],
    );
  }
}
