import 'dart:convert';
import 'package:http/http.dart';
import 'package:movie_app/src/model/movie.dart';

class ApiMovie {
  const ApiMovie(this._client);
  static const String url = 'https://yts.mx/api/v2/list_movies.json';
  final Client _client;

  Future<List<Movie>> getMovies(int page) async {
    final Response response = await _client.get(
      Uri.parse(
        '$url?limit=20&page=$page',
      ),
    );

    final Map<String, dynamic> body = jsonDecode(response.body) as Map<String, dynamic>;
    final Map<String, dynamic> data = body['data'] as Map<String, dynamic>;

    return (data['movies'] as List<dynamic>)
        .map((dynamic item) => Movie.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
