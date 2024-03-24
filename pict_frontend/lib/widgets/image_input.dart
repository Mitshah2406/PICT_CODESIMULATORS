import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pict_frontend/utils/constants/app_colors.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.image});
  final void Function(File image) image;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;

  void _takePicture() async {
    final ImagePicker imagePicker = ImagePicker();

    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxHeight: 600);

    if (pickedImage == null) {
      return;
    }

    File fileImage = File(pickedImage.path);

    setState(() {
      _selectedImage = fileImage;
    });

    widget.image(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: _takePicture,
      icon: const Icon(
        Icons.camera,
        color: TColors.primaryGreen,
      ),
      label: Text(
        "Add Image to Report",
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: TColors.primaryGreen),
      ),
    );

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      height: 180,
      width: double.infinity,
      child: content,
    );
  }
}
