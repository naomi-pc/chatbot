import 'package:chatbot/screens/playlist.dart';
import 'package:chatbot/screens/welcome.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:math';

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
  Map<dynamic, dynamic> _messages ={
    "user": [],
    "bot": [],
  };
  List<dynamic>? respuestas;
  
  Future<void> loadJsonData() async {
    String jsonData = await rootBundle.loadString('assets/responses.json');
    Map<String, dynamic> data = jsonDecode(jsonData);
    respuestas = data["respuestas"];
  }

  @override
  void initState(){
    super.initState();
    loadJsonData();
    // print(accessTokenChido);
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        if (_messages["user"] == null) {
          _messages["user"] = [];
        }
        randomValue = Random().nextInt(respuestas!.length.toInt()); 
        _messages["user"].add(_controller.text);
        
        _controller.clear();
      });
    }
    _messages["bot"].add(respuestas?[randomValue]);
    print(_messages["bot"].length);
    if(_messages["bot"].length == 5){
      // _messages["bot"].add("end messages");
      // sendData(_messages["user"]);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Playlist(messages: List<String>.from(_messages["user"])),
        ),
      );
      
      _messages ={
        "user": [],
        "bot": [],
      };
    }
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
        actions: [
          IconButton(onPressed: (){}, 
          icon: (widget.profileData != null && widget.profileData!['images'] != null && widget.profileData!['images'].isNotEmpty)
          ? Image.network(widget.profileData!['images'][0]['url'])
          : Container())
        ],
        backgroundColor: const Color(0xFFE7F6FB),
        title: Center(
          child: Text(
            'Welcome, ${widget.profileData?['display_name'] ?? 'Unknown'}' ,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Colors.black87,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: messageWidgets,
                  // children: _messages.entries.map((entry) {
                  //   return Column(
                  //     children: entry.key == "user" ? (entry.value as List<dynamic>).map((message) => messageBox(message.toString())).toList() 
                  //     :  (entry.value as List<dynamic>).map((message) => messageBoxBot(message.toString())).toList(),
                  //   );
                  // }).toList(),
                ),
              ),
            ),
            Padding(
              padding:const EdgeInsets.fromLTRB(2.0, 15.0, 2.0, 15.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Start chatting',
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: const Color(0xFFFFFFFF),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(
                            color: Color(0xFF1974AB), // Set the border color here
                            width: 2.0, // Set the border width
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFF1974AB)),
                    onPressed: _sendMessage,
                  ),
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
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 123, 180, 215),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          message, // Use the passed message parameter here
          style: const TextStyle(color: Colors.white),
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
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 79, 182, 47),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          message, // Use the passed message parameter here
          style: const TextStyle(color: Colors.white),
        ),
      ),
    ),
  );
}

}
