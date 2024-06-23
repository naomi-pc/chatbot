import 'package:chatbot/screens/welcome.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({
    super.key,
  });

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 3), () {}); 
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Welcome()),
    );
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1974AB),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 150, // Set the desired width of the image
                height: 150, // Set the desired height of the image
                child: Image.asset(
                  'assets/logoplain.png',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "MoodTune",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35.0,
                  color: Colors.white
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
