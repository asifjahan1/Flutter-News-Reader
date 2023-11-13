import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatelessWidget {

  final String newsTitle;
  final String newsContent;
  final String imageUrl;
  final String publishedAt;
  //final String url;
  final int index; // Accept the index as a parameter

  const NewsDetailScreen({
    super.key,
    required this.newsTitle,
    required this.newsContent,
    required this.imageUrl,
    required this.publishedAt,
    //required this.url,
    required this.index, // Declare the index parameter
  });

  _launchURL(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
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
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          },
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.black.withOpacity(0.7),
              size: 22.0,
            ),
          ),
          title: Text(newsTitle,
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold),
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

          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ), // Display the image
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        newsTitle,
                        style: GoogleFonts.roboto(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        newsContent,
                        style: const TextStyle(fontSize: 15),
                      ),
                      //SizedBox(height: 16),
                      const SizedBox(height: 10),
                      Text(
                        'Published at: $publishedAt',
                        style: const TextStyle(
                            fontSize: 16, color: Colors.grey),
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.redAccent,
          isExtended: true,
          shape: LinearBorder.start(alignment: 1.0),
          elevation: 5.0,

          onPressed: () {
            // Add your action when the button is pressed
            print('Floating Action Button Pressed!');
          },
          child: const Text('Read More'),
        ),

      ),
    );
  }
}
