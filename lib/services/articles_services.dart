import '../models/articles_models.dart';
import 'http_services.dart';

class ArticlesServices {
  static final ArticlesServices _singleton = ArticlesServices._internal();

  final HTTPService _httpService = HTTPService();

  factory ArticlesServices() {
    return _singleton;
  }

  ArticlesServices._internal();

  Future<List<Articles>?> getArticles() async {
    String path = "v2/everything";

    String query = 'politics';
    final encodedQuery = Uri.encodeComponent(query);
    var queryParameters = {
      'q': encodedQuery,
    };
    await _httpService.setup(apiKey: '5f0390dd03a44a86a1ba70b0377a553b');
    // create a variable to perform the request
    var response =
        await _httpService.get(path, queryParameters: queryParameters);

    if (response?.statusCode == 200 && response?.data != null) {
      List data = response?.data['articles'];

      List<Articles> articles = data.map((e) => Articles.fromJson(e)).toList();

   

      return articles;
    }

    return null;
  }
}
