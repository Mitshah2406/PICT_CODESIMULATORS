import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pict_frontend/models/Event.dart';
import 'package:pict_frontend/pages/Events/event_enroll_succes.dart';
import 'package:pict_frontend/services/event_service.dart';
import 'package:pict_frontend/utils/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventRoleSelectionPage extends StatefulWidget {
  const EventRoleSelectionPage({super.key, required this.event});
  final Event event;

  @override
  State<EventRoleSelectionPage> createState() => _EventRoleSelectionPageState();
}

class _EventRoleSelectionPageState extends State<EventRoleSelectionPage> {
  int selectedButton = 0;
  bool checkedValue = false;

  List<String> roles = ['participant', 'volunteer'];

  String? _id;

  Future<Null> getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _id = prefs.getString("userId");
    });
  }

  @override
  void initState() {
    _id = "";
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Select a role to participate: ",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(),
              ),
              const SizedBox(
                height: 20,
              ),
              OptionRadio(
                  text: 'Participant',
                  index: 0,
                  icon: FontAwesomeIcons.p,
                  selectedButton: selectedButton,
                  press: (val) {
                    setState(() {
                      selectedButton = val;
                    });
                  }),
              const Divider(),
              OptionRadio(
                  text: 'Volunteer',
                  index: 1,
                  selectedButton: selectedButton,
                  icon: FontAwesomeIcons.v,
                  press: (val) {
                    setState(() {
                      selectedButton = val;
                    });
                  }),
              const SizedBox(
                height: 20,
              ),
              CheckboxListTile(
                title: Text(
                  "I hereby, accept all the rules and regulations for the event and follow the responsibilities as per mentioned above for the role I selected.",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                ),
                value: checkedValue,
                onChanged: (newValue) {
                  setState(() {
                    checkedValue = newValue!;
                  });
                },
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (checkedValue == true && _id != '') {
                    // Register the user based on role
                    String res = await EventService.registerEvent(
                      _id,
                      widget.event.id,
                      roles[selectedButton],
                    );
                    if (res == "ok") {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const EventEnrollSuccessPage(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Failed to register into event. Please try again later"),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Please accept the rules before registering into event.",
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primaryGreen,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text("Register"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class OptionRadio extends StatefulWidget {
  final String text;
  final int index;
  final int selectedButton;
  final Function press;
  final IconData icon;

  const OptionRadio({
    super.key,
    required this.text,
    required this.index,
    required this.icon,
    required this.selectedButton,
    required this.press,
  });

  @override
  OptionRadioPage createState() => OptionRadioPage();
}

class OptionRadioPage extends State<OptionRadio> {
  int id = 1;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.press(widget.index);
      },
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  // height: 60.0,
                  child: Theme(
                data: Theme.of(context).copyWith(
                    unselectedWidgetColor: Colors.grey,
                    disabledColor: Colors.blue),
                child: Column(children: [
                  RadioListTile(
                    title: Row(
                      children: [
                        Container(
                          height: 30,
                          width: 30,
                          decoration: const BoxDecoration(
                            color: TColors.primaryYellow,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: Icon(
                            widget.icon,
                            color: TColors.black,
                            size: 20,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          " ${widget.text}",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(fontWeight: FontWeight.w400),
                          softWrap: true,
                        ),
                      ],
                    ),
                    /*Here the selectedButton which is null initially takes place of value after onChanged. Now, I need to clear the selected button when other button is clicked */
                    groupValue: widget.selectedButton,
                    value: widget.index,
                    activeColor: TColors.primaryGreen,
                    onChanged: (val) async {
                      debugPrint('Radio button is clicked onChanged $val');
                      // setState(() {
                      //   debugPrint('Radio button setState $val');
                      //   selectedButton = val;
                      //   debugPrint('Radio button is clicked onChanged $widget.index');
                      // });
                      // SharedPreferences prefs = await SharedPreferences.getInstance();
                      // prefs.setInt('intValue', val);
                      widget.press(widget.index);
                    },
                    toggleable: true,
                  ),
                ]),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
