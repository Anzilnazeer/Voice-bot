// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_bot/api/api.dart';
import 'package:voice_bot/colors/colors.dart';
import 'package:voice_bot/model/chat_model.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isListeniing = false;
  SpeechToText speechtotext = SpeechToText();
  var text = 'Hold to record';
  final List<ChatBubble> messages = [];
  final scrollController = ScrollController();
  scrollcontroller() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: buttonColor,
        toolbarHeight: 80,
        title: const Text('Voice Bot'),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 100,
              color: Colors.black,
              child: Text(
                text,
                style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 10),
                  width: double.infinity,
                  height: 450,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 29, 29, 29),
                  ),
                  child: ListView.builder(
                    itemCount: messages.length,
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ChatBubble(
                        text: messages[index].text,
                        type: messages[index].type,
                      );
                    },
                  )),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: buttonColor.withOpacity(0.5),
                  spreadRadius: isListeniing ? 15 : 0,
                  blurRadius: 20,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: GestureDetector(
              onTapDown: (details) async {
                if (!isListeniing) {
                  var available = await speechtotext.initialize();
                  if (available) {
                    setState(() {
                      isListeniing = true;
                      speechtotext.listen(
                        listenFor: const Duration(minutes: 1),
                        onResult: (result) {
                          setState(() {
                            text = result.recognizedWords;
                          });
                        },
                      );
                    });
                  }
                }
              },
              onTapUp: (details) async {
                setState(() {
                  isListeniing = false;
                });
                speechtotext.stop();

                messages.add(ChatBubble(text: text, type: Message.user));
                var msg = await Api.sendMessage(text);

                setState(() {
                  messages
                      .add(ChatBubble(text: msg.toString(), type: Message.bot));
                });
              },
              child: CircleAvatar(
                backgroundColor: buttonColor,
                radius: 30,
                child: Icon(
                  isListeniing ? Icons.mic : Icons.mic_none,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  String text;
  Message type;
  ChatBubble({
    Key? key,
    required this.text,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          backgroundColor: buttonColor,
          child: Icon(
            Icons.computer,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
            ),
            child: Text(
              text,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: const Color.fromARGB(255, 71, 20, 20)),
            ),
          ),
        ),
      ],
    );
  }
}
