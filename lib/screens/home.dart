import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chatbot/screens/loading.dart';
import 'package:chatbot/screens/playlist.dart';
import 'package:chatbot/screens/welcome.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class Home extends StatefulWidget {
  final String? accessToken;
  final Map<dynamic, dynamic>? profileData;

  const Home({Key? key, this.accessToken, this.profileData}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final accessTokenChido = AccessToken().token;

  var randomValue;
  final TextEditingController _controller = TextEditingController();
  Map<dynamic, dynamic> _messages = {
    "user": [],
    "bot": [],
  };
  List<dynamic>? respuestas;
  bool firstMessageSent = false;
  bool isTyping = false;

  Future<void> loadJsonData() async {
    String jsonData = await rootBundle.loadString('assets/enResponses.json');
    Map<String, dynamic> data = jsonDecode(jsonData);
    respuestas = data["respuestas"];
  }

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        if (_messages["user"] == null) {
          _messages["user"] = [];
        }
        randomValue = Random().nextInt(respuestas!.length);
        _messages["user"].add(_controller.text);

        _controller.clear();
        firstMessageSent = true;
        _simulateBotResponse();
      });
    }
  }

  void _simulateBotResponse() {
    setState(() {
      isTyping = true;
    });
    Future.delayed(Duration(seconds: 2), () {

      if (_messages["bot"].length == 3) {
        setState(() {
          _messages["bot"].add("I've analized your messages, i'll try to get your emotions");
          isTyping = false;
        });
        // _messages["bot"].add("I've analized your messages, i'll try to get your emotions");
        Future.delayed(Duration(seconds: 4), () {
          Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                Load(messages: List<String>.from(_messages["user"])),
                // Playlist(messages: List<String>.from(_messages["user"])),
          ),
        );
        });
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) =>
        //         Load(messages: List<String>.from(_messages["user"])),
        //         // Playlist(messages: List<String>.from(_messages["user"])),
        //   ),
        // );
      }
      else{
        setState(() {
        _messages["bot"].add(respuestas?[randomValue]);
        isTyping = false;
      });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> messageWidgets = [];

    int maxLength = _messages.values.fold(0, (max, list) => list.length > max ? list.length : max);

    for (int i = 0; i < maxLength; i++) {
      if (i < _messages["user"]!.length) {
        messageWidgets.add(messageBox(_messages["user"]![i]));
      }
      if (i < _messages["bot"]!.length) {
        messageWidgets.add(messageBoxBot(_messages["bot"]![i]));
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(100, 15, 15, 20),
            child: Row(
              children: [
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Moody",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.black87,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            "  Online",
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15.0,
                              color: Colors.black54,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(width: 85,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(40.0),
                  child: Image.asset(
                    'assets/closeup.jpg',
                    fit: BoxFit.cover,
                    height: 41.0,
                    width: 41.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!firstMessageSent)
                      Column(
                        children: [
                          SizedBox(
                            width: 150,
                            height: 150,
                            child: Image.asset(
                              'assets/intro.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(
                            'Hello, ${AccessToken().name}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'Tell me your mood today, I\'ll do my best',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'to recommend you the perfect playlist!',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 300,)
                        ],
                      ),
                    ...messageWidgets,
                    if (isTyping)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20), // Adjust spacing as needed
                                LoadingAnimationWidget.waveDots(
                                  color: Colors.grey.shade600,
                                  size: 25,
                                ),
                              // SizedBox(height: 0), // Adjust spacing as needed
                            ],
                          ),
                        ),
                      ),

                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(2.0, 15.0, 2.0, 15.0),
              child: Row(
                children: [
                  Expanded(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 40.0,
                        maxHeight: 200.0,
                      ),
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(color: Colors.black),
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'What\'s on your mind?',
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: const Color(0xFFFFFFFF),
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                              color: Color(0xFFE8E8EE),
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color.fromARGB(255, 123, 180, 215)),
                    iconSize: 30.0,
                    onPressed: _sendMessage,
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Padding messageBox(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 240.0,
          ),
          child: BubbleSpecialThree(
            text: message,
            color: Color.fromARGB(255, 123, 180, 215),
            tail: true,
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Padding messageBoxBot(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 240.0,
          ),
          child: BubbleSpecialThree(
            text: message,
            color: Color(0xFFE8E8EE),
            tail: true,
            isSender: false,
          ),
        ),
      ),
    );
  }
}