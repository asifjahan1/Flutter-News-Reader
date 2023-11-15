import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: unused_import
import 'package:url_launcher_android/url_launcher_android.dart';

class NewsDetailScreen extends StatelessWidget {
  final String author;
  final String title;
  final String description;
  final String urlToImage;
  final String publishedAt;
  final String content;
  final String url;
  //final String articleUrl;
  final int index; // Accept the index as a parameter

  const NewsDetailScreen({
    super.key,
    required this.author,
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.publishedAt,
    required this.url,
    required this.content,
    //required this.articleUrl,
    required this.index, // Declare the index parameter
  });

/*
  Future<void> _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url); // Convert the String to Uri
      if (await canLaunch(uri.toString())) {
        await launch(uri.toString());
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }
  */

// Example usage
//_launchURL('https://www.example.com');

/*
  Future<void> _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error launching URL: $e');
      }
    }
  }
  */
  // this code works well
  Future<void> _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      await launch(uri.toString());
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.black.withOpacity(0.7),
              size: 22.0,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            /*
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
            */
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  urlToImage,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ), // Display the image
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      author,
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                    Text(
                      title,
                      style: GoogleFonts.roboto(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 18),
                    ),
                    //SizedBox(height: 16),

                    const SizedBox(height: 10),
                    Text(
                      url,
                      style: const TextStyle(fontSize: 10, color: Colors.cyan),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Published at: $publishedAt',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    /*
                    const SizedBox(height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _launchURL(url); // Function to open the URL
                      },
                      child: Text('Read More'),
                    ),
                    */

                    const SizedBox(
                      height: 50,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ElevatedButton(
                          onPressed: () {
                            _launchURL(url); // Use the stored URL
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.red, // Set the background color
                          ),
                          child: const Text(
                            'Read More',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

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
