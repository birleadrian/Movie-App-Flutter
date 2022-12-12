import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:movie_app/src/data/api_movie.dart';
import 'package:movie_app/src/model/movie.dart';
import 'package:movie_app/src/model/torrent.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        scaffoldBackgroundColor: Colors.blue, //<-- SEE HERE
      ),
      home: const MoviePage(title: 'Movies'),
      routes: <String, WidgetBuilder>{
        '/details': (BuildContext context) => const DetailsPage(),
      },
    );
  }
}

class MoviePage extends StatefulWidget {
  const MoviePage({super.key, required this.title});

  final String title;

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final List<Movie> _moviesList = <Movie>[];
  final ScrollController _controller = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getMovies();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      _getMovies();
    }
  }

  Future<void> _getMovies() async {
    final Client client = Client();
    final ApiMovie apiMovie = ApiMovie(client);
    final List<Movie> response = await apiMovie.getMovies(1);

    setState(() {
      _moviesList.addAll(response);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Center(
          child: Text(
            'Movies',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: ListView.builder(
        controller: _controller,
        itemCount: _moviesList.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (_moviesList.length == index) {
            if (_isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return const SizedBox.shrink();
            }
          }
          final Movie movie = _moviesList[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/details',
                arguments: movie,
              );
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Image.network(
                movie.mediumImage,
              ),
            ),
          );
        },
      ),
    );
  }
}

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context)!.settings.arguments! as Movie;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${movie.title} (${movie.year})',
          style: const TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.amberAccent,
      body: ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Image.network(
                  movie.mediumImage,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                children: <Widget>[
                  Text(
                    ' Rating: ${movie.rating.toString()}',
                    style: const TextStyle(color: Colors.black87),
                  ),
                  Text(
                    ' Runtime: ${movie.runtime.toString()} minutes',
                    style: const TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                movie.summary,
                style: const TextStyle(
                  color: Colors.black45,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'Available in:',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20,
              ),
            ),
          ),
          for (final Torrent torrent in movie.torrents)
            ListTile(
              title: Column(
                children: <Widget>[
                  Text(
                    '${torrent.quality} ${torrent.type}',
                    style: const TextStyle(color: Colors.black87),
                  ),
                  const SizedBox(width: 50),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('Download with quality ${torrent.quality} started!');
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text(
                      'Download',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
