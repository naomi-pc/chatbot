import 'package:chatbot/screens/welcome.dart';
import 'package:chatbot/sendData.dart';
import 'package:flutter/material.dart';

class Playlist extends StatefulWidget {
  final List<String> messages ;
  const Playlist( { Key? key, required this.messages }) : super(key: key);

  @override
  _PlaylistState createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  final accessTokenChido = AccessToken().token;
  late String prediccionModelo;
  Future<void> mandarPrediccion() async{
    prediccionModelo = sendData(widget.messages, accessTokenChido);
  }
  void initState(){
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Envio de Datos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("nuestro bot detectó que estas ${ prediccionModelo=="1"? "felíz" : "tiste"}"),
      ),
    );
  }
}