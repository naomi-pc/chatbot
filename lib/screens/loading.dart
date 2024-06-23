import 'package:chatbot/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Load extends StatefulWidget {
  const Load({
    super.key,
  });

  @override
  _LoadState createState() => _LoadState();
}

class _LoadState extends State<Load> {
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Making a playlist for you",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 21.0,
                ),
              ),
              const Text(
                "Moody is analizying your mood",
                style: TextStyle(
                  fontSize: 17.0,
                ),
              ),
              SizedBox(
                width: 220, // Set the desired width of the image
                height: 220, // Set the desired height of the image
                child: Image.asset(
                  'assets/you.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              
              LoadingAnimationWidget.inkDrop(
                color: Color.fromARGB(255, 123, 180, 215),
                size: 50,
              ),
            ],
            
          ),
        ),
      ),
    );
  }

}
