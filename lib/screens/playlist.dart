import 'package:chatbot/screens/welcome.dart';
import 'package:chatbot/sendData.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Playlist extends StatefulWidget {
  final List<String> messages ;
  const Playlist( { Key? key, required this.messages }) : super(key: key);

  @override
  _PlaylistState createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  final accessTokenChido = AccessToken().token;
  int? prediccionModelo ;
  List<String> idTracks = [];
  Future<void> mandarPrediccion() async{
    prediccionModelo = sendData(widget.messages, accessTokenChido);
  }
  void initState(){
    super.initState();
    mandarPrediccion();
    idTracks = sendIdTracks() as List<String>;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Envio de Datos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("nuestro bot detectó que estas ${ prediccionModelo==1? "felíz" : "triste"}"),
            const Text("así que creamos una playlist con tu mood"),
            ElevatedButton(onPressed: (){
              
              final Uri url = Uri.parse(AccessToken().url);
              _launchURL(url);
            }, child: const Text("Esperamos la disfrutes")),
            
          ],
        ),
      ),
    );
  }
  Future<void> _launchURL(Uri url) async {
  if (!await launchUrl(url)) {
    throw 'Could not launch $url';
  }
}
}