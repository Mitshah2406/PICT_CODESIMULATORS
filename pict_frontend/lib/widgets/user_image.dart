import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pict_frontend/utils/constants/app_constants.dart';

final _imagePicker = ImagePicker();

class UserImage extends StatefulWidget {
  UserImage({super.key, required this.onPickedImage, required this.userImage});
  final void Function(File pickedImage) onPickedImage;
  String? userImage;

  @override
  State<UserImage> createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  File? _pickedImage;

  void captureFromGallery() async {
    final captureImageFromGalley = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: double.infinity,
    );

    if (captureImageFromGalley == null) {
      return;
    }

    setState(() {
      _pickedImage = File(captureImageFromGalley.path);
    });

    widget.onPickedImage(_pickedImage!);
  }

  void captureImage() async {
    final captureImage = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: double.infinity,
    );

    if (captureImage == null) {
      return;
    }

    setState(() {
      _pickedImage = File(captureImage.path);
    });

    widget.onPickedImage(_pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 90,
          child: SizedBox(
            width: 180, // Diameter of the CircleAvatar is twice the radius
            height: 180,
            child: ClipOval(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: _pickedImage != null
                  ? Image.file(
                      _pickedImage!,
                      fit: BoxFit.cover,
                    )
                  : widget.userImage == "null"
                      ? Image.asset(
                          "assets/images/logo.png",
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          "${AppConstants.IP}/userImages/${widget.userImage}",
                          fit: BoxFit.cover,
                        ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: captureImage,
              icon: const Icon(Icons.camera),
              label: Text(
                "Add Image",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            TextButton.icon(
              onPressed: captureFromGallery,
              icon: const Icon(Icons.image),
              label: Text(
                "Open Galley",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            )
          ],
        )
      ],
    );
  }
}
