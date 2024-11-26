import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:studd/services/api_sevices.dart';

class homeScreen extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<homeScreen> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('STUDD'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for songs...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchForMusic();
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  var track = _searchResults[index];
                  return ListTile(
                    title: Text(track['name']),
                    subtitle: Text(track['artists'][0]['name']),
                    leading: Image.network(track['album']['images'][0]['url']),
                    onTap: () {
                      _playMusic(track['preview_url']);
                    },
                  );
                },
              ),
            ),
            _isPlaying
                ? IconButton(
                    icon: Icon(Icons.pause),
                    onPressed: () {
                      _pauseMusic();
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void _searchForMusic() async {
    String query = _searchController.text;
    var results = await searchMusic(query);
    setState(() {
      _searchResults = results;
    });
  }

  void _playMusic(String url) async {
    await _audioPlayer.setUrl(url);
    _audioPlayer.play();
    setState(() {
      _isPlaying = true;
    });
  }

  void _pauseMusic() async {
    await _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }
}
