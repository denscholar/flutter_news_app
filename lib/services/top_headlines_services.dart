import '../models/top_headlines.dart';
import 'http_services.dart';

class TopHeadlineServices {
  static final TopHeadlineServices _singleton = TopHeadlineServices._internal();

  final HTTPService _httpService = HTTPService();

  factory TopHeadlineServices() {
    return _singleton;
  }

  TopHeadlineServices._internal();

  Future<List<TopHeadline>?> getTopHealines() async {
    String path = "v2/top-headlines";

    var queryParameters = {
      'sources': 'techcrunch',
    };
    await _httpService.setup(apiKey: 'ac83872944824e2dac01329b60f3de56');
    // create a variable to perform the request
    var response =
        await _httpService.get(path, queryParameters: queryParameters);

    if (response?.statusCode == 200 && response?.data != null) {
      List data = response?.data['articles'];
      List<TopHeadline> topHeadlines =
          data.map((e) => TopHeadline.fromJson(e)).toList();

      return topHeadlines;
    }

    return null;
  }
}
