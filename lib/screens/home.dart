import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Home extends StatefulWidget {
  final String? accessToken;

  const Home({Key? key, this.accessToken}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _controller = TextEditingController();

  Map<dynamic, dynamic>? profileData;
  
  final List<String> _messages = [];
  
  
  
  @override
  void initState(){
  super.initState();
    if (widget.accessToken != null) {
      _getProfileData(widget.accessToken!);
    }
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add(_controller.text);
        _controller.clear();
      });
    }
  }

  Future<void> _getProfileData(String token) async {
    final profileUrl = Uri.https('api.spotify.com', '/v1/me');

    final response = await http.get(
      profileUrl,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    
    if (response.statusCode == 200) {
      setState(() {
        profileData = jsonDecode(response.body);
      });
    } else {
    // print('Respuesta del servidor: ${profileData}');
      throw Exception('Error obteniendo los datos del perfil');
      
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFE7F6FB),
        title: Center(
          child: Text(
            'Welcome, ${profileData?['display_name'] ?? 'Unknown'}' ,
            style: TextStyle(
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
                  children: _messages
                      .map((message) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 123, 180, 215),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  message,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
            Padding(
              padding:EdgeInsets.fromLTRB(2.0, 15.0, 2.0, 15.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Start chatting',
                        hintStyle: TextStyle(color: Colors.grey),
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
}
