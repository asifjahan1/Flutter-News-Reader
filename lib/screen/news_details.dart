import 'package:flutter/material.dart';

class NewsDetailScreen extends StatelessWidget {

  final String newsTitle;
  final String newsContent;
  final String imageUrl;
  final int index; // Accept the index as a parameter

  const NewsDetailScreen({
    super.key,
    required this.newsTitle,
    required this.newsContent,
    required this.imageUrl,
    required this.index, // Declare the index parameter
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('News Details',style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.orange,
            Colors.amber,
            Colors.lime,
            //Colors.lightGreen,
            Colors.amber,
            //Colors.lightGreen,
            Colors.lime,
            Colors.amber,
            Colors.orange
          ]

          ),
        ),

        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(imageUrl), // Display the image

              SizedBox(height: 16),
              Text(
                newsTitle,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                newsContent,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
          /*
          Text(
                'Index: $index', // Display the index
                style: TextStyle(fontSize: 16),
              ),
              */
            ],
          ),
        ),
      ),
    );
  }
}
