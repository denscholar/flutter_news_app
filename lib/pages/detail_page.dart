import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/articles_models.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.articles});

  final Articles? articles;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  void _launchURL(Uri uri, bool inApp) async {
    try {
      if (await canLaunchUrl(uri)) {
        if (inApp) {
          await launchUrl(
            uri,
            mode: LaunchMode.inAppWebView,
          );
        } else {
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
        }
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(widget.articles?.source?.name ?? "Unknow Source"),
      ),
      body: _buildUI(context),
    );
  }

  Widget _buildUI(BuildContext context) {
    return Column(
      children: [
        _newsImage(),
        _newTitle(),
        _content(context),
      ],
    );
  }

  Widget _newsImage() {
    return Container(
      height: 250.0,
      width: double.infinity,
      decoration: const BoxDecoration(),
      child: Image.network(
        "${widget.articles?.urlToImage}",
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _newTitle() {
    // Parse the publishedAt date string into a DateTime object
    DateTime publishedDate = DateTime.parse("${widget.articles?.publishedAt}");
    // Format the DateTime object into a human-readable string
    String formattedDate = DateFormat.yMMMd().format(publishedDate);

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 25.0, right: 10.0),
            child: Text(
              "${widget.articles?.title} - ${widget.articles?.author ?? "Unknown"}",
              style: const TextStyle(
                  fontSize: 23.0,
                  height: 1.3,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEB6505)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 10.0, right: 10.0),
            child: Text(
              "Date Published:  $formattedDate",
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          )
        ],
      ),
    );
  }

  Widget _content(BuildContext context) {
    final urlPage = "${widget.articles?.url}";
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 10.0, right: 10.0),
          child: Text(
            "${widget.articles?.content}",
            style: const TextStyle(fontSize: 15.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 10.0, right: 10.0),
          child: ElevatedButton(
              onPressed: () => _launchURL(Uri.parse(urlPage), false),
              child: const Text("Click here read to read more")),
        )
      ],
    );
  }
}



/*

async {
                  final String? urlString = widget.articles?.url;

                  if (urlString == null || urlString.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('URL is not available.')),
                    );
                    return;
                  }
                  final Uri url = Uri.parse(urlString);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Could not launch $url')),
                  );
                },


*/