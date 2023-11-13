import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newspaper_app/const.dart';
import 'package:newspaper_app/customhttp.dart';
import 'package:newspaper_app/model/model.dart';
import 'package:newspaper_app/screen/news_details.dart';
import 'package:newspaper_app/screen/search_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

enum NewsEvent { fetchNews }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isOnline = true;
  List<String> list = <String>[
    'relevancy',
    'popularity',
    'publishedAt',
  ];
  String sortBy = 'popularity';
  int pageNo = 1;
  int currentIndex = 1;

  @override
  void initState() {
    super.initState();
    checkConnectivity(); // Check connectivity when the page is loaded
    loadCachedArticles(); // Load cached articles when the page is loaded
  }

  Future<void> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isOnline = (connectivityResult == ConnectivityResult.none) ? false : true;
    });
  }

  Future<void> loadCachedArticles() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedArticles = prefs.getStringList('cached_articles') ?? [];

    /*
    setState(() {
      var newsArticles = cachedArticles;
    });

     */
  }

  Future<void> cacheArticles(List<String> articles) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('cached_articles', articles);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Colors.black54,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        duration: const Duration(seconds: 1),
                        type: PageTransitionType.bottomToTop,
                        child: SearchPage(),
                        inheritTheme: true,
                        ctx: context),
                  );
                },
                icon: Icon(Icons.search),
                iconSize: 35,
                color: Colors.white,
              ),
            )
          ],
          backgroundColor: Colors.lightGreen,
          title: Text(
            'News Reader',
            style: myStyle(30, Colors.black, FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: isOnline
            ? Container(
          decoration: const BoxDecoration(
            color: Colors.white,

            gradient: LinearGradient(colors: [
              //Colors.white,
              //Colors.amber,
              //Colors.lime,
              Colors.white,
              Colors.white,
              ////Colors.amber,
              //Colors.lightGreen,
              //Colors.lime,
              //Colors.amber,
              //Colors.orange
            ],

            ),
          ),
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 60,
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            if (pageNo > 1) {
                              pageNo--;
                              setState(() {});
                            }
                          },
                          child: Text(
                            'PREV',
                            style: GoogleFonts.roboto(),
                          )),
                      Flexible(
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                            children: List.generate(
                              7,
                                  (index) => GestureDetector(
                                onTap: () {
                                  pageNo = (index + 1);
                                  setState(() {});
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.1),
                                      border: Border.all(
                                        color: index == pageNo - 1
                                            ? Colors.blueGrey
                                            : Colors.black,
                                      ),
                                      borderRadius:
                                      BorderRadius.circular(10)),
                                  child: Text(
                                    (index + 1).toString(),
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                      index == pageNo - 1 ? 20 : 12,
                                      color: index == pageNo - 1
                                          ? Colors.red
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (pageNo < 10) {
                              pageNo++;
                              setState(() {});
                            }
                          },
                          child: Text(
                            'NEXT',
                            style: GoogleFonts.roboto(),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 40,
                    // color: Color.fromARGB(255, 165, 156, 71),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Category',
                          style: myStyle(30, Colors.deepPurple),
                        ),
                        Container(
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                              border: Border.all(
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(14)),
                          child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: DropdownButton<String>(
                              value: sortBy,
                              icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                              elevation: 15,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                  color: Colors.red),
                              onChanged: (String? value) {
                                setState(() {
                                  sortBy = value!;
                                });
                              },
                              items: list.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                FutureBuilder<List<Articles>>(
                  future: CustomHttp()
                      .fetchAllNewsData(pageNo: pageNo, sortBy: sortBy),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Waiting for network!', style: TextStyle(color: Colors.grey.withOpacity(0.9), fontWeight: FontWeight.bold ));
                    } else if (snapshot.data == null) {
                      return Text('No data found!');
                    }

                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsDetailScreen(
                                  newsTitle:
                                  '${snapshot.data![index].title}',
                                  newsContent:
                                  '${snapshot.data![index].description}',
                                  imageUrl:
                                  '${snapshot.data![index].urlToImage}',
                                  publishedAt: '${snapshot.data![index].publishedAt}',
                                  index: index,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                              top: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Color.fromARGB(255, 102, 102, 101),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              leading: Image.network(
                                  '${snapshot.data![index].urlToImage}'),
                              title: Text(
                                '${snapshot.data![index].title}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                  '${snapshot.data![index].description}'),
                            ),
                          ),
                        );
                      },
                    );

                    /*
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(
                                top: 10,
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      color:
                                      Color.fromARGB(255, 102, 102, 101)),
                                  borderRadius: BorderRadius.circular(8)),
                              child: ListTile(
                                leading: Image.network(
                                    '${snapshot.data![index].urlToImage}'),
                                title: Text(
                                  '${snapshot.data![index].title}',
                                  style: TextStyle(fontWeight: FontWeight.bold),


                                ),
                                subtitle: Text(
                                    '${snapshot.data![index].description}'),
                              ),

                            );

                          });

                      */
                  },
                )
              ],
            ),
          ),
        )
            : const Center(
          child: Text(
            'You are offline',
            style: TextStyle(
                fontSize: 30,
                color: Colors.red,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
