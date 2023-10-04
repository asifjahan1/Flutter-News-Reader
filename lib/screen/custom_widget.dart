import 'package:flutter/material.dart';
import 'package:newspaper_app/model/model.dart';

class NewsListWidget extends StatelessWidget {
  final List<Articles> articles;

  const NewsListWidget({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return ListTile(
          title: Text(article.title ?? ''),
          subtitle: Text(article.description ?? ''),
          // Customize this widget to display other information as needed
        );
      },
    );
  }
}
