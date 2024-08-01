import 'package:flutter/material.dart';
import 'package:flutter_news_app/pages/detail_page.dart';

import '../models/articles_models.dart';
import '../services/articles_services.dart';

class AllStoriesPage extends StatefulWidget {
  const AllStoriesPage({super.key});

  @override
  State<AllStoriesPage> createState() => _AllStoriesPageState();
}

class _AllStoriesPageState extends State<AllStoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        "All Stories",
        textAlign: TextAlign.end,
      )),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return FutureBuilder(
        future: ArticlesServices().getArticles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("Unable to fetch data at this time"),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No articles found"));
          }
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Articles articles = snapshot.data![index];

                double titleHeight = 24.0; // Estimated height for the title
                double subtitleHeight =
                    20.0; // Estimated height for the subtitle
                double descriptionHeight =
                    40.0; // Estimated height for the description
                double verticalPadding = 16.0; // Padding around the text

                double imageHeight = titleHeight +
                    subtitleHeight +
                    descriptionHeight +
                    (2 * verticalPadding);
                return ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return DetailPage(articles: articles);
                    }));
                  },
                  isThreeLine: true,
                  title: Text(
                    articles.source?.name ?? "Unknow Source",
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Container(
                    width: 100.0,
                    height: imageHeight,
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        "${articles.urlToImage}",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error, color: Colors.red);
                        },
                      ),
                    ),
                  ),
                  subtitle: Text(
                    "${articles.title}",
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                );
              });
        });
  }
}
