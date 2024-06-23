import 'package:chatbot/apiModels/apiModels.dart';
import 'package:chatbot/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Welcome extends StatefulWidget {
  const Welcome({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {

  //claves
  final String clientId = '5c6ea34f75714054ad7a12683f405d95';
  final String clientSecret = '24a9e10df5d0496fa02aba240a58cb8f';
  final String redirectUri = 'myapp://auth';
  final String scopes = 'user-read-private user-read-email playlist-modify-public';

  //datos para mostrar
  String? accessToken;

  Map<dynamic, dynamic>? profileData ;

  Future<void> login(BuildContext context) async {
    final authUrl = Uri.https(
      'accounts.spotify.com',
      '/authorize',
      {
        'response_type': 'code',
        'client_id': clientId,
        'redirect_uri': redirectUri,
        'scope': scopes,
      },
    );
    // print(authUrl.toString());
    try {
      
      final result = await FlutterWebAuth.authenticate(
        url: authUrl.toString(),
        callbackUrlScheme: 'myapp',
      );

      final code = Uri.parse(result).queryParameters['code'];
      print(code.toString());
      if (code != null) {
        final token = await _getAccessToken(code);
        setState(() {
          accessToken = token;
        });
        
        profileData = await getProfileData(accessToken!);
        
      } else {
        print('Error obteniendo el código de autorización');
      }
    } catch (e) {
      
      if (e is PlatformException && e.code == 'CANCELED') {
        
        print('Usuario canceló el inicio de sesión');
      } else {
        
        print('Error durante la autenticación: $e');
      }
    }
  }

  Future<String> _getAccessToken(String code) async {
    
    final tokenUrl = Uri.https('accounts.spotify.com', '/api/token');

    final response = await http.post(
      tokenUrl,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
      },
      body: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirectUri,
      },
    );
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      AccessToken().token = body['access_token'];
      
      return body['access_token'];
    } else {
      throw Exception('Error obteniendo el token de acceso');
    }
  }

  

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
                  onPressed: () =>{ 
                    login(context),
                    AccessToken().name= profileData?['display_name'] ?? 'Anon',
                    if (AccessToken().name != null){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Home(accessToken: accessToken, profileData: profileData),
                        ),
                        )
                      }
                    },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1974AB),
                  ),
                  child: const Text(
                    'Log in with Spotify Account',
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
class AccessToken {
  static final AccessToken _instance = AccessToken._internal();

  factory AccessToken() {
    return _instance;
  }

  AccessToken._internal();

  String _token = '';
  String _id = '';
  String _url = '';
  String _name = '';
  int _prediccion = 0;

  String get token => _token;
  String get id => _id;
  String get url => _url;
  String get name => _name;
  int get prediccion => _prediccion;
  

  set token(String value) {
    _token = value;
  }
  set id(String value) {
    _id = value;
  }
  set url(String value) {
    _url = value;
  }
  set name(String value) {
    _name = value;
  }
  set prediccion(int value) {
    _prediccion = value;
  }
}
