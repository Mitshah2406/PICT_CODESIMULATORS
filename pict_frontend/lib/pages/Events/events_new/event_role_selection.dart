import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pict_frontend/pages/Events/events_new/event_enroll_succes.dart';
import 'package:pict_frontend/utils/constants/app_colors.dart';

class EventRoleSelectionPage extends StatefulWidget {
  const EventRoleSelectionPage({super.key});

  @override
  State<EventRoleSelectionPage> createState() => _EventRoleSelectionPageState();
}

class _EventRoleSelectionPageState extends State<EventRoleSelectionPage> {
  int selectedButton = 0;
  bool checkedValue = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Events",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CircleAvatar(
              child: Image.asset("assets/images/overlap1.png"),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Select Role To participate: ",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(),
            ),
            const SizedBox(
              height: 20,
            ),
            OptionRadio(
                text: 'Participant',
                index: 0,
                icon: FontAwesomeIcons.a,
                selectedButton: selectedButton,
                press: (val) {
                  selectedButton = val;
                  setState(() {});
                }),
            const Divider(),
            OptionRadio(
                text: 'Volunteer',
                index: 1,
                selectedButton: selectedButton,
                icon: FontAwesomeIcons.a,
                press: (val) {
                  selectedButton = val;
                  setState(() {});
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
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const EventEnrollSuccessPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primaryGreen,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              child: const Text("Register"),
            )
          ],
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
  // QuestionController controllerCopy =QuestionController();

  int id = 1;
  late bool _isButtonDisabled;

  @override
  void initState() {
    _isButtonDisabled = false;
  }

  final int _selected = 0;

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
                    activeColor: Colors.green,
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
