// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class LastFMService {
//   static const String baseUrl = 'https://ws.audioscrobbler.com/2.0/';
//   static const String apiKey =
//       '64e5f311f7299658b3b578665ee7dcdf'; // Replace with your Last.fm API key

//   // Function to search for tracks
//   Future<List<Map<String, dynamic>>> searchTracks(String query) async {
//     final url = Uri.parse(
//         '$baseUrl?method=track.search&track=$query&api_key=$apiKey&format=json');
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//       return List<Map<String, dynamic>>.from(
//           data['results']['trackmatches']['track']);
//     } else {
//       throw Exception('Failed to search tracks');
//     }
//   }

//   // Function to get album details by album name
//   Future<Map<String, dynamic>> getAlbumDetails(String albumName) async {
//     final url = Uri.parse(
//         '$baseUrl?method=album.getinfo&album=$albumName&api_key=$apiKey&format=json');
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to fetch album details');
//     }
//   }

//   // Function to get artist details
//   Future<Map<String, dynamic>> getArtistDetails(String artistName) async {
//     final url = Uri.parse(
//         '$baseUrl?method=artist.getinfo&artist=$artistName&api_key=$apiKey&format=json');
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to fetch artist details');
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> getAccessToken() async {
  String clientId = '3aba06ce91944fe893b1dab2c0d56dfb'; // Your Client ID
  String clientSecret =
      '8bcc47baaf2843d2b80383ca0dedb4dc'; // Your Client Secret

  // Combine Client ID and Client Secret to create base64-encoded string
  String credentials = '$clientId:$clientSecret';
  String base64Credentials = base64Encode(utf8.encode(credentials));

  // Send POST request to get the access token
  final response = await http.post(
    Uri.parse('https://accounts.spotify.com/api/token'),
    headers: {
      'Authorization': 'Basic $base64Credentials',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'grant_type': 'client_credentials',
    },
  );

  if (response.statusCode == 200) {
    // If the request is successful, parse and return the access token
    var data = jsonDecode(response.body);
    return data['access_token'];
  } else {
    throw Exception('Failed to get access token');
  }
}

Future<List<dynamic>> searchMusic(String query) async {
  String accessToken = await getAccessToken();

  final response = await http.get(
    Uri.parse('https://api.spotify.com/v1/search?q=$query&type=track'),
    headers: {
      'Authorization': 'Bearer $accessToken', // Use the access token here
    },
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    // Return the list of tracks
    return data['tracks']['items'];
  } else {
    throw Exception('Failed to search music');
  }
}
