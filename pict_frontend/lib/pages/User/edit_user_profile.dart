import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pict_frontend/pages/User/user_dashboard.dart';
import 'package:pict_frontend/pages/User/user_profile.dart';
import 'package:pict_frontend/providers/event_notifier.dart';
import 'package:pict_frontend/services/auth_service.dart';
import 'package:pict_frontend/utils/constants/app_colors.dart';
import 'package:pict_frontend/widgets/user_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  EditProfilePage(
      {super.key,
      required this.userId,
      required this.name,
      required this.email,
      required this.userImage});
  String? userId;
  String? name;
  String? email;
  String? userImage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _form = GlobalKey<FormState>();
  final TextEditingController _userFirstNameController =
      TextEditingController();
  final TextEditingController _userLastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? selectedImage;

  @override
  void initState() {
    // selectedImage = File(widget.userImage!);
    List<String> nameArr = widget.name!.split(" ");
    String firstName = nameArr[0];
    String lastName = nameArr[1];

    _userFirstNameController.text = firstName;
    _userLastNameController.text = lastName;
    _emailController.text = widget.email!;
    super.initState();
  }

  @override
  void dispose() {
    _userFirstNameController.dispose();
    _userLastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveCredentials() async {
    if (_form.currentState!.validate()) {
      // print(_userFirstNameController.text +
      //     " " +
      //     _userLastNameController.text +
      //     " " +
      //     _emailController.text);

      Map<dynamic, dynamic> res = await AuthServices.editProfile(
          _userFirstNameController.text,
          _userLastNameController.text,
          _emailController.text,
          selectedImage?.path);

      print("Ress");
      print(res);

      if (res["result"] == true) {
        print("yess ");
        Fluttertoast.showToast(
          msg: "Profile saved successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: TColors.primaryGreen,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        print(res);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('name',
            "${_userFirstNameController.text} ${_userLastNameController.text}");
        await prefs.setString('image', res["imagePath"].toString());

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const UserDashboard();
        }));
      } else {
        Fluttertoast.showToast(
          msg: "Failed to save profile",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: TColors.primaryGreen,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _form,
                    child: Column(
                      children: [
                        UserImage(
                          onPickedImage: (pickedImage) {
                            selectedImage = pickedImage;
                          },
                          userImage: widget.userImage!,
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        TextFormField(
                          validator: (value) {
                            if (value == "") {
                              return "Enter Your First Name";
                            }
                            return null;
                          },
                          controller: _userFirstNameController,
                          keyboardType: TextInputType.multiline,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            border: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            hintText: "Enter Your First Name",
                            hintStyle: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 14),
                          ),
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        // ? Last Name Field
                        TextFormField(
                          validator: (value) {
                            if (value == "") {
                              return "Enter Your Last Name";
                            }
                            return null;
                          },
                          // initialValue: lastName,
                          controller: _userLastNameController,
                          keyboardType: TextInputType.multiline,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            border: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            hintText: "Enter Your Last Name",
                            hintStyle: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 14),
                          ),
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        // ? Email Field
                        TextFormField(
                          validator: (value) {
                            if (value == "") {
                              return "Enter Your Email Address";
                            } else if (value!.contains('@')) {
                              return null;
                            } else {
                              return "Enter valid Email Address";
                            }
                          },
                          readOnly: true,
                          controller: _emailController,
                          keyboardType: TextInputType.multiline,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.normal),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            border: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            hintText: "Enter Your Email Address",
                            hintStyle: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 14),
                          ),
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        ElevatedButton(
                          onPressed: _saveCredentials,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(10),
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                          child: Text(
                            "Save Changes",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
