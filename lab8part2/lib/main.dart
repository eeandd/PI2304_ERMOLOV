import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<List<News>> fetchNews(http.Client client) async {
  final response = await client.get(
    Uri.parse(
      'https://kubsau.ru/api/getNews.php?key=6df2f5d38d4e16b5a923a6d4873e2ee295d0ac90',
    ),
  );
  return compute(parseNews, response.body);
}

List<News> parseNews(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<News>((json) => News.fromJson(json)).toList();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class News {
  final String id;
  final String active_from;
  final String title;
  final String preview_text;
  final String preview_picture_src;
  final String detail_page_url;
  final String detail_text;
  final String last_modified;

  const News({
    required this.id,
    required this.active_from,
    required this.title,
    required this.preview_text,
    required this.preview_picture_src,
    required this.detail_page_url,
    required this.detail_text,
    required this.last_modified,
  });
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['ID'] as String,
      active_from: json['ACTIVE_FROM'] as String,
      title: json['TITLE'] as String,
      preview_text: json['PREVIEW_TEXT'] as String,
      preview_picture_src: json['PREVIEW_PICTURE_SRC'] as String,
      detail_page_url: json['DETAIL_PAGE_URL'] as String,
      detail_text: json['DETAIL_TEXT'] as String,
      last_modified: json['LAST_MODIFIED'] as String,
    );
  }
}

class NewsList extends StatelessWidget {
  const NewsList({Key? key, required this.news}) : super(key: key);
  final List<News> news;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: news.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white,
          child: Column(
            children: [
              Image.network(news[index].preview_picture_src),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            news[index].last_modified,
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                          Text(
                            news[index].title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Divider(),
                          Text(
                            Bidi.stripHtmlIfNeeded(news[index].preview_text),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
    // return GridView.builder(
    //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: 2,
    //   ),
    //   itemCount: news.length,
    //   itemBuilder: (context, index) {
    //     return Image.network(news[index].preview_picture_src);
    //   },
    // );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<News>>(
        future: fetchNews(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return NewsList(news: snapshot.data!);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    const appTitle = 'Лента новостей КубГАУ';
    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}
