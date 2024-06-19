import 'package:chatbot/sendData.dart';
import 'package:flutter/material.dart';

class Playlist extends StatefulWidget {
  final List<String> messages ;
  const Playlist( { Key? key, required this.messages }) : super(key: key);

  @override
  _PlaylistState createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {

  void initState(){
    super.initState();
    ;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Envio de Datos'),
      ),
      body: Container(
        child: Text(sendData(widget.messages)),
      ),
    );
  }
}