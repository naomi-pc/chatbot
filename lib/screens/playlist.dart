import 'package:chatbot/screens/home.dart';
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
    prediccionModelo = await sendData(widget.messages, accessTokenChido);
  }
  void initState(){
    super.initState();
    mandarPrediccion();
    idTracks = sendIdTracks() as List<String>;
  }
  @override
  Widget build(BuildContext context) {
    String imagePath = prediccionModelo == 1 ? 'assets/happy.png' : 'assets/sad.png';

    return Scaffold(
      body: Padding(
        padding:EdgeInsets.fromLTRB(30, 160, 30, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Moody detectó que estas ${prediccionModelo == 1 ? "felíz" : "triste"}",
              style: TextStyle(
                fontSize: 17.0,
                color: Colors.black87,
              ),
            ),
            const Text(
              "así que creamos una playlist con tu mood",
              style: TextStyle(
                fontSize: 17.0,
                color: Colors.black87,
              ),
            ),
            SizedBox(
              width: 220, // Set the desired width of the image
              height: 220, // Set the desired height of the image
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover, // Ensure the image covers the box
              ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                final Uri url = Uri.parse(AccessToken().url);
                _launchURL(url);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE7F6FB),
              ),
              child: const Text(
                'Esperamos la disfrutes',
                style: TextStyle(
                  fontSize: 17.0,
                  color: Color(0xFF1974AB),
                ),
              ),
            ),
            SizedBox(height: 15,),
            Center( // Wrap the Row with Center
              child: Row(
                mainAxisSize: MainAxisSize.min, // Add this line
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "No es tu mood?",
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                  ), 
                  SizedBox(width: 5,),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );
                    },
                    child: Text(
                      "Intenta otra vez",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Color(0xFF1974AB),
                      ),
                    ),
                  )
                ],
              ),
            ),
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