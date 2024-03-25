import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pict_frontend/bloc/chat_bloc.dart';
import 'package:pict_frontend/models/ChatBot.dart';
import 'package:pict_frontend/utils/constants/app_colors.dart';
import 'package:pict_frontend/utils/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final ChatBloc chatBloc = ChatBloc();
  TextEditingController textEditingController = TextEditingController();

  String? _id;
  String? _userImage;

  Future<Null> getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _id = prefs.getString("userId");
      _userImage = prefs.getString("image");
    });
  }

  @override
  void initState() {
    _id = "";
    _userImage = "";
    getSession();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "WasteBot",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: _userImage!.isNotEmpty
                ? CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: SizedBox(
                      width: 180,
                      height: 180,
                      child: ClipOval(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: _userImage == "null"
                            ? Image.asset(
                                "assets/images/villager.png",
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                "${AppConstants.IP}/userImages/$_userImage",
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  )
                : const CircularProgressIndicator(),
          )
        ],
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        bloc: chatBloc,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case ChatSuccessState:
              List<ChatMessageModel> messages =
                  (state as ChatSuccessState).messages;
              return Container(
                padding: const EdgeInsets.only(top: 10),
                width: double.maxFinite,
                height: double.maxFinite,
                decoration: const BoxDecoration(
                    // image: DecorationImage(
                    //     opacity: 0.5,
                    //     image: AssetImage("assets/images/waste.png"),
                    //     fit: BoxFit.cover),
                    ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(
                              top: 10,
                              bottom: 12,
                              left: 16,
                              right: 16,
                            ),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: messages[index].role == "user"
                                  ? Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? TColors.white
                                      : TColors.primaryYellow.withOpacity(.7)
                                  : Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? TColors.accentGreen
                                      : TColors.primaryGreen.withOpacity(.6),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  messages[index].role == "user"
                                      ? "User"
                                      : "Waste Bot",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: messages[index].role == "user"
                                        ? TColors.info
                                        : TColors.error,
                                  ),
                                ),
                                const Divider(
                                  color: TColors.darkerGrey,
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  messages[index].parts.first.text,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          height: 1.2, color: TColors.black),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    if (chatBloc.generating)
                      Row(
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: Lottie.asset('assets/loader.json'),
                          ),
                        ],
                      ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: textEditingController,
                              style: const TextStyle(color: Colors.black),
                              cursorColor: Theme.of(context).primaryColor,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                hintText: "Ask Something From WasteBot",
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade400),
                                filled: true,
                                // focusedBorder: OutlineInputBorder(
                                //   borderRadius: BorderRadius.circular(100),
                                //   //   borderSide: BorderSide(
                                //   //       color: Theme.of(context).),
                                // ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          InkWell(
                            onTap: () {
                              if (textEditingController.text.isNotEmpty) {
                                String text = textEditingController.text;
                                textEditingController.clear();
                                chatBloc.add(
                                  ChatGenerateNewTextMessageEvent(
                                      inputMessage: text),
                                );
                              }
                            },
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 28,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: const Center(
                                  child: Icon(Icons.send, color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );

            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
