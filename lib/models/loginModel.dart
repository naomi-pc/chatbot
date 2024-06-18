import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginModel extends StatefulWidget {
  const LoginModel({ Key? key }) : super(key: key);

  @override
  _LoginModelState createState() => _LoginModelState();
}

class _LoginModelState extends State<LoginModel> {

  void init(){
    setState(() {
        // _profileData = jsonDecode(response.body);
        login(context);
      });
  }
  //claves
  final String clientId = '5c6ea34f75714054ad7a12683f405d95';
  final String clientSecret = '24a9e10df5d0496fa02aba240a58cb8f';
  final String redirectUri = 'myapp://auth';
  final String scopes = 'user-read-private user-read-email';

  //datos para mostrar
  String? _accessToken;
  Map<dynamic, dynamic>? _profileData;
  Map<dynamic, dynamic>? _trackData;

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
          _accessToken = token;
        });

        await _getProfileData(token);
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
      return body['access_token'];
    } else {
      throw Exception('Error obteniendo el token de acceso');
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
        _profileData = jsonDecode(response.body);
      });
    } else {
    print('Respuesta del servidor: ${response.body}');
      throw Exception('Error obteniendo los datos del perfil');
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}