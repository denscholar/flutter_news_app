import 'package:flutter/material.dart';

import '../models/articles_models.dart';
import '../models/top_headlines.dart';
import '../services/articles_services.dart';
import '../services/top_headlines_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: const Color(0xFFFFFFFF),
        leadingWidth: 100.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.0),
        ),
        actions: const [
          Icon(Icons.notifications),
          SizedBox(width: 20.0),
        ],
      ),
      body: _buildUI(context),
    );
  }

  Widget _buildUI(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _topHeader(),
          _scrollableTopView(),
          _viewAllButtons(),
          _listViewVertical(),
        ],
      ),
    );
  }

  Widget _topHeader() {
    return const SizedBox(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 8.0,
        ),
        child: Text(
          "Top Headlines",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _scrollableTopView() {
    return Expanded(
      child: FutureBuilder(
          future: TopHeadlineServices().getTopHealines(),
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
            return SizedBox(
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    TopHeadline topHeadline = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        child: Stack(
                          children: [
                            Container(
                              width: 300.0,
                              height: 300,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14.0),
                                  color: Colors.black),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    "${topHeadline.urlToImage}",
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  )),
                            ),
                            Container(
                              width: 300.0,
                              height: 300.0,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            Positioned(
                                left: 10.0,
                                right: 10.0,
                                top: 70.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    topHeadline.title ?? "No Title",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20.0),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    );
                  }),
            );
          }),
    );
  }

  Widget _viewAllButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, bottom: 15.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Expanded(
            child: Text(
              "Top Stories",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
              child: InkWell(
            onTap: () {},
            child: const Text(
              "View All",
              textAlign: TextAlign.right,
            ),
          )),
        ],
      ),
    );
  }

  Widget _listViewVertical() {
    return Expanded(
      child: FutureBuilder(
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
                itemCount: 5,
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
                    onTap: () {},
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
          }),
    );
  }
}




// child: SizedBox(
//           height: 200.0,
//           child: ListView(
//             scrollDirection: Axis.horizontal,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(5.0),
//                 child: InkWell(
//                   child: Container(
//                     width: 200.0,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.0),
//                       color: Colors.grey,
//                     ),
//                     child: const Center(child: Text("Container one")),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(5.0),
//                 child: InkWell(
//                   child: Container(
//                     width: 200.0,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.0),
//                       color: Colors.grey,
//                     ),
//                     child: const Center(child: Text("Container one")),
//                   ),
//                 ),
//         c:\Users\Afrip      ),
//               Padding(
//                 padding: const EdgeInsets.all(5.0),
//                 child: InkWell(
//                   child: Container(
//                     width: 200.0,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.0),
//                       color: Colors.grey,
//                     ),
//                     child: const Center(child: Text("Container one")),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(5.0),
//                 child: InkWell(
//                   child: Container(
//                     width: 200.0,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.0),
//                       color: Colors.grey,
//                     ),
//                     child: const Center(child: Text("Container one")),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(5.0),
//                 child: InkWell(
//                   child: Container(
//                     width: 200.0,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.0),
//                       color: Colors.grey,
//                     ),
//                     child: const Center(child: Text("Container one")),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),