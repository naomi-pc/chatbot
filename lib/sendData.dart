import 'dart:convert';
import 'package:chatbot/screens/welcome.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


var prediccion;
late List<Track> _tracks = [];
String id = AccessToken().id;
late String playlistId = "";
late String ss = "";
List<String> idTracks = [];
  
String sendData(List<dynamic> messages, String token) {
  // List<String> userMessages = List<String>.from(messages);
  // print(userMessages);
  final Map<String, List<dynamic>> jsonMap = {
    "array_strings": messages
  };

  String array_strings = jsonEncode(jsonMap);
  // sendToApi(array_strings);
  prediccion = 1;
  print(token);
  _getRecomendations(token, prediccion);

  // return (array_strings);
  return prediccion.toString();
}

Future<void> sendToApi(String messages) async{
  
  final String url = 'http://127.0.0.1:5000/predict';

    try {
      // Enviar la solicitud POST
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: messages,
      );

      // Verificar el estado de la respuesta
      if (response.statusCode == 200) {
        // La solicitud fue exitosa
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        prediccion = responseBody['respuesta'];
        print('Respuesta del servidor: ${responseBody['respuesta']}');
      } else {
        // Hubo un error en la solicitud
        print('Error en la solicitud: ${response.statusCode}');
        print('Respuesta del servidor: ${response.body}');
      }
    } catch (e) {
      // Manejar cualquier error en la solicitud
      print('Error en la solicitud: $e');
    }
}

Future<void> _getRecomendations(String token, int valence) async {

    double min = 0;
    double max = 0;
    
    if (valence ==0){
      min = 0;
      max= 0.5;
    }
    else{
      min = 0.5;
      max = 1;
      
    }
    final recomUrl = Uri.https(
      'api.spotify.com',
      '/v1/recommendations',
      {
        
        'limit': '20',
        'seed_tracks': '7cRGgrQ9eg8V8A4FsSj020,59Q0mA0Bq3bqfV5ySjfTbn',
        'seed_genres': 'ska,romance,rock',
        'min_valence': min.toString(),
        'max_valence': max.toString(),
        'min_energy': min.toString(),
        'max_energy': max.toString(),
        'min_danceability': min.toString(),
        'max_danceability': max.toString(),
      },
    );

    final responseRecomendations = await http.get(
      recomUrl,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    
    if (responseRecomendations.statusCode == 200) {
      final parsedTracks = parseTracks(responseRecomendations.body);
      playlistId = await createPlaylist(token, id);
      _tracks = parsedTracks;
      for (Track track in _tracks) {
        // print(' ${track.id}');
        idTracks.add(track.id);
      }
      playlistId = playlistId;
        // this.ss= ss;
      // print(idTracks);
      final ss = await addTracksToPlaylist(token, idTracks, playlistId); 
    } 
    else {
      print(recomUrl);
      print('Respuesta del servidor: ${responseRecomendations.body}');
      throw Exception('Error obteniendo los datos de la cancion');
      
    }
  }
List<Track> parseTracks(String responseBody) {
    final parsed = json.decode(responseBody);
    return (parsed['tracks'] as List).map<Track>((json) => Track.fromJson(json)).toList();
  }

class Track{
  final String name;
  final String id;

  Track({
    required this.name,
    required this.id
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    
    return Track(
      name: json['name'],
      id: json['uri']

    );
  }
}

Future<String> createPlaylist(String token, String idUser) async {
  Map<String, dynamic>? playListData;
  final urlss = Uri.https('api.spotify.com', '/v1/users/$idUser/playlists');

  final response = await http.post(
    urlss,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "name": "test",
      "description": "New playlist test description",
      "public": true,
    }),
  );

  if (response.statusCode == 201) {
    playListData = jsonDecode(response.body);
    return playListData!["id"];
  } else {
    print('Respuesta del servidor: ${response.body}');
    throw Exception('Error creando la playlist');
  }
}

Future<String> addTracksToPlaylist(String token, List<String> idTracks, String idPlaylist) async{
  // String result = jsonEncode(idTracks);
  List<String> uris = idTracks.map((id) => id).toList();
  Map<String, dynamic> snap;
  // print(result);
  final url = Uri.https("api.spotify.com",
  "/v1/playlists/$idPlaylist/tracks");

  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
        "uris": 
            // result.toString()
            // idTracks
            // result
            uris
      ,
        "position": 0
      })
    );
  if (response.statusCode == 200) {
    snap = jsonDecode(response.body);
    return snap["snapshot_id"];
  } else {
    print('Respuesta del servidor: ${response.body}');
    throw Exception('Error aniadiendo elementos a la playlist');
  }
}
