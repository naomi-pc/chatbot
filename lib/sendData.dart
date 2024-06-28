import 'dart:convert';
import 'package:chatbot/screens/welcome.dart';
import 'package:http/http.dart' as http;
import 'package:chat_bubbles/chat_bubbles.dart';
import 'dart:math';


late List<Track> _tracks = [];
String id = AccessToken().id;
late String playlistId = "";
late String ss = "";
List<String> idTracks = [];
List<String> idTracksCopy = [];
  
Future<int> sendData(List<dynamic> messages, String token) async {
  final Map<String, List<dynamic>> jsonMap = {
    "array_strings": messages
  };
  print(messages);
  String array_strings = jsonEncode(jsonMap);

  // descomentar para conexion a api
  // sendToApi(array_strings);
  int? prediccion = await sendToApi(array_strings);
  print(prediccion);
  // int? prediccion =0;
  late int predChida ;
  // List<String> userMessages = List<String>.from(messages);
  // print(userMessages);
  
  // prediccion = 1;
  if (prediccion != null) {
    _getRecomendations(token, prediccion);
    idTracksCopy = idTracks;
    idTracks = [];
    // return (array_strings); // No es necesario devolver esto aquí
    
    predChida = prediccion;
    
  } else {
    print('No se obtuvo una predicción válida.');
  }
  
  return predChida;
  
}

List<String> sendIdTracks() {
  // print("idtracks");
  print(idTracksCopy);
  return idTracksCopy;
}

Future<int?> sendToApi(String messages) async{
  
  final String url = 'http://192.168.22.222:5000/predict';

    try {
      // Enviar la solicitud POST
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: messages,
      );

      print(response.statusCode);
      // Verificar el estado de la respuesta
      if (response.statusCode == 200) {
        // La solicitud fue exitosa
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        print('cuerpo de la respuesta valida:');
        print(response.body);
        print('Respuesta del servidor: ${responseBody['prediccionReal']}');
        return responseBody['prediccionReal'] as int;
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

Future<void> _getRecomendations(String token, int prediccion) async {

    double min = 0;
    double max = 0;
    String mood = '';

    print("para la recomendiacion, la prediccion es:$prediccion");
    if (prediccion ==0){
      min = 0;
      max= 0.5;
      mood = 'sad';
    }
    else{
      min = 0.5;
      max = 1;
      mood = 'happy';
      
    }
    final recomUrl = Uri.https(
      'api.spotify.com',
      '/v1/recommendations',
      {
        
        'limit': '20',
        // 'seed_tracks': '7cRGgrQ9eg8V8A4FsSj020,59Q0mA0Bq3bqfV5ySjfTbn',
        'seed_genres': 'rock, heavy-metal, mexican rock',
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
      playlistId = await createPlaylist(token, id, mood);
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
      //print(recomUrl);
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

Future<String> createPlaylist(String token, String idUser, String mood) async {
  Map<String, dynamic>? playListData;
  final urlss = Uri.https('api.spotify.com', '/v1/users/$idUser/playlists');
  var happy_playlist = {
    'Sunshine Vibes': 'A playlist to brighten your day and lift your spirits.',
    'Feel-Good Favorites': 'Enjoy these feel-good tracks that are sure to make you smile.',
    'Joyful Jams': 'Upbeat songs to fill you with joy and happiness.',
    'Happy Hits': 'The best hits to keep you in a happy mood.',
    'Uplifting Anthems': 'Anthems that will uplift your soul and energize you.'
  };

  var sad_playlist = {
    'Tearful Tunes': 'Songs that will help you let out your emotions.',
    'Heartbreak Hits': 'Music to accompany your heartbreak and sorrow.',
    'Blue Days': 'Melancholic tracks for when you are feeling down.',
    'Broken Hearts Club': 'Songs for those who have loved and lost.',
    'Crying in the Rain': 'Emotional tunes to cry along with.'
  };
  
  String playlist_name = '';
  String playlist_description = '';

  
  var random = Random();
  
  if (mood == 'happy') {
    var randomKey = happy_playlist.keys.elementAt(random.nextInt(happy_playlist.length));
    playlist_name = randomKey;
    playlist_description = happy_playlist[randomKey]!;
  } else if (mood == 'sad') {
    var randomKey = sad_playlist.keys.elementAt(random.nextInt(sad_playlist.length));
    playlist_name = randomKey;
    playlist_description = sad_playlist[randomKey]!;
  } else {
    playlist_name = 'test';
    playlist_description = 'New playlist test description';
  }

  final response = await http.post(
    urlss,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "name": playlist_name,
      "description": playlist_description,
      "public": true,
    }),
  );

  if (response.statusCode == 201) {
    playListData = jsonDecode(response.body);
    AccessToken().url = playListData!["external_urls"]["spotify"];
    print(AccessToken().url);
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
            uris,
        "position": 0
      })
    );
  if (response.statusCode == 201) {
    snap = jsonDecode(response.body);
    return snap["snapshot_id"];
  } else {
    print('Respuesta del servidor: ${response.body}');
    print(response.statusCode);
    throw Exception('Error aniadiendo elementos a la playlist');
    
  }
}
