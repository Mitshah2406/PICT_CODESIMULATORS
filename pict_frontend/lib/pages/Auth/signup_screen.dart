import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:pict_frontend/pages/Auth/signin_screen.dart';
import 'package:pict_frontend/pages/Recycler/recycler_home_screen.dart';
import 'package:pict_frontend/pages/User/user_dashboard.dart';

import 'package:pict_frontend/services/auth_service.dart';
import 'package:pict_frontend/utils/constants/app_colors.dart';
import 'package:pict_frontend/utils/constants/app_constants.dart';
import 'package:pict_frontend/utils/session/SharedPreference.dart';

// String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var logger = Logger();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController =
      TextEditingController(text: "");
  final TextEditingController _lastNameController =
      TextEditingController(text: "");
  final TextEditingController _emailController =
      TextEditingController(text: "");
  final TextEditingController _mobileNoController =
      TextEditingController(text: "");
  final TextEditingController _passwordController =
      TextEditingController(text: "");

  String? selectedOption = "user";

  List<String> options = ["user", "recycler"];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileNoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppConstants.bgColorAuth,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50, shape: BoxShape.circle),
                  child: SvgPicture.asset(
                    AppConstants.registerIcon,
                    fit: BoxFit.cover,
                    width: 100,
                    height: 50,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: TColors.primaryGreen,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // const Text(
                //   "Enter Your Basic Details...",
                //   style: TextStyle(
                //     fontSize: 14,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.black38,
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                // const SizedBox(
                //   height: 20,
                // ),
                Divider(
                  color: Colors.grey.shade300,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 8,
                        ),

                        // ? First Name Field
                        const Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
                          child: Text(
                            "First Name: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == "") {
                              return "Enter Your First Name";
                            }
                            return null;
                          },
                          controller: _firstNameController,
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
                          height: 8,
                        ),

                        // ? Last Name Field
                        const Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
                          child: Text(
                            "Last Name: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == "") {
                              return "Enter Your Last Name";
                            }
                            return null;
                          },
                          controller: _lastNameController,
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
                          height: 8,
                        ),

                        // ? Email Field
                        const Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
                          child: Text(
                            "Email: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                            textAlign: TextAlign.start,
                          ),
                        ),
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
                          height: 10,
                        ),

                        // ? Mobile No Field
                        const Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
                          child: Text(
                            "Mobile Number: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == "") {
                              return "Enter Your Mobile Number";
                            } else if (value!.length != 10) {
                              return "Enter Your Valid Mobile Number";
                            }
                            return null;
                          },
                          controller: _mobileNoController,
                          keyboardType: TextInputType.number,
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
                            hintText: "Enter Your Mobile Number",
                            hintStyle: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 14),
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        // ? Password Field
                        const Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
                          child: Text(
                            "Password: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == "") {
                              return "Enter Your Password";
                            }
                            return null;
                          },
                          controller: _passwordController,
                          obscureText: true,
                          keyboardType: TextInputType.text,
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
                            hintText: "Enter Your Password",
                            hintStyle: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 14),
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        // ? Choice
                        const Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: Text(
                            "Are You A ? ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Wrap(
                          spacing: 8.0,
                          children: [
                            FilterChip(
                              autofocus: true,
                              selectedColor: TColors.primaryGreen,
                              label: const Text('User'),
                              selected: selectedOption == 'user',
                              onSelected: (bool selected) {
                                setState(() {
                                  if (selected) {
                                    selectedOption = 'user';
                                  }
                                });
                              },
                            ),
                            FilterChip(
                              selectedColor: TColors.primaryGreen,
                              label: const Text('Recycler'),
                              selected: selectedOption == 'recycler',
                              onSelected: (bool selected) {
                                setState(() {
                                  if (selected) {
                                    selectedOption = 'recycler';
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        // ChipsChoice.single(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 0, vertical: 0),
                        //   value: selectedValue,
                        //   onChanged: ((val) {
                        //     setState(() {
                        //       selectedValue = val;
                        //     });
                        //   }),
                        //   choiceItems: C2Choice.listFrom(
                        //     source: options,
                        //     value: (i, v) => i,
                        //     label: (i, v) => capitalize(v),
                        //   ),
                        //   choiceActiveStyle: C2ChoiceStyle(
                        //     color: TColors.primaryGreen,
                        //     borderColor: TColors.primaryGreen,
                        //     borderRadius: BorderRadius.circular(5),
                        //   ),
                        //   choiceStyle: const C2ChoiceStyle(
                        //     color: Color.fromARGB(255, 62, 145, 64),
                        //     borderRadius: BorderRadius.all(
                        //       Radius.circular(5),
                        //     ),
                        //   ),
                        // ),

                        const SizedBox(
                          height: 10,
                        ),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                Map<String, dynamic> response =
                                    await AuthServices.signUp(
                                  _firstNameController.text,
                                  _lastNameController.text,
                                  _emailController.text,
                                  _mobileNoController.text,
                                  _passwordController.text,
                                  selectedOption,
                                );

                                if (response["result"] != "exist" &&
                                    response["result"]["message"] == "ok") {
                                  Fluttertoast.showToast(
                                    msg:
                                        "Your Account has been successfully created.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: TColors.primaryGreen,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );

                                  // Entire user
                                  var account = response["result"]["data"];

                                  // Push the user data into sharedPreferences
                                  String res = await Utils.setSession(account);

                                  if (res == "ok") {
                                    if (account["role"] == "user") {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const UserDashboard(),
                                        ),
                                      );
                                    } else if (account["role"] == "recycler") {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const RecyclerHomePage(),
                                        ),
                                      );
                                    }
                                  }
                                } else if (response["result"] == "exist") {
                                  Fluttertoast.showToast(
                                    msg:
                                        "Email Already Exist. Try using another email",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "Internal Server Error",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: TColors.primaryGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const SignInPage();
                                }));
                              },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
