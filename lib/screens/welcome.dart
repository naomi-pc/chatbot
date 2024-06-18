import 'package:chatbot/screens/home.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  const Welcome({
    super.key,
  });

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7F6FB),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 15, 40, 0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 100,
              ),
              ClipOval(
                child: SizedBox(
                  width: 250, // Set the width of the circle
                  height: 250, // Set the height of the circle
                  child: Image.asset(
                    'assets/logo3d.jpg',
                    fit: BoxFit.cover, // Ensure the image covers the circle
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Get musical recommendations",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              const Text(
                "based on your mood",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1974AB),
                  ),
                  child: const Text(
                    'Let\'s chat now',
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
