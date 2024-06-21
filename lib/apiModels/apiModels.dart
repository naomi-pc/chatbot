
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;


Future<Map<dynamic, dynamic>?> getProfileData(String token) async {
  Map<dynamic, dynamic>? profileData;
    final profileUrl = Uri.https('api.spotify.com', '/v1/me');

    final response = await http.get(
      profileUrl,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    
    if (response.statusCode == 200) {
        profileData = jsonDecode(response.body);
        return profileData;
    } else {
    // print('Respuesta del servidor: ${profileData}');
      throw Exception('Error obteniendo los datos del perfil');
      
    }
  }