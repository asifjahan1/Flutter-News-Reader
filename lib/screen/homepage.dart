import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newspaper_app/customhttp.dart';
import 'package:newspaper_app/model/model.dart';
import 'package:newspaper_app/screen/news_details.dart';
import 'package:newspaper_app/screen/search_page.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
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

  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isOnline = (connectivityResult == ConnectivityResult.none) ? false : true;
    });
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
                      ctx: context,
                    ),
                  );
                },
                icon: const Icon(Icons.search),
                iconSize: 35,
                color: Colors.white,
              ),
            )
          ],
          backgroundColor: Colors.black12.withOpacity(0.8),
          title: const Text(
            'News Reader',
            style: TextStyle(
                fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: isOnline
            ? Container(
                decoration: const BoxDecoration(
                  color: Colors.white10,
                ),
                padding: EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                style: TextStyle(fontFamily: 'Roboto'),
                              ),
                            ),
                            Flexible(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: List.generate(
                                  5,
                                  (index) => GestureDetector(
                                    onTap: () {
                                      pageNo = (index + 1);
                                      setState(() {});
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.1),
                                        border: Border.all(
                                          color: index == pageNo - 1
                                              ? Colors.blueGrey
                                              : Colors.black,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
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
                                style: TextStyle(fontFamily: 'Roboto'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Select Category',
                                style: TextStyle(
                                    fontSize: 30, color: Colors.deepPurple),
                              ),
                              Container(
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  border: Border.all(
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: DropdownButton<String>(
                                    value: sortBy,
                                    icon: const Icon(
                                        Icons.arrow_drop_down_circle_outlined),
                                    elevation: 15,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
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
                                      },
                                    ).toList(),
                                  ),
                                ),
                              ),
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
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return const Text(
                              'Waiting for network!',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            );
                          } else if (snapshot.data == null) {
                            return const Text('No data found!');
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
                                        author:
                                            '${snapshot.data![index].author}',
                                        title: '${snapshot.data![index].title}',
                                        description:
                                            '${snapshot.data![index].description}',
                                        urlToImage:
                                            '${snapshot.data![index].urlToImage}',
                                        content:
                                            '${snapshot.data![index].content}',
                                        publishedAt:
                                            '${snapshot.data![index].publishedAt}',
                                        url: '${snapshot.data![index].url}',
                                        index:
                                            index, // Assuming there's a URL in your model
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: const Color.fromARGB(
                                          255, 102, 102, 101),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ListTile(
                                    leading: Image.network(
                                        '${snapshot.data![index].urlToImage}'),
                                    title: Text(
                                      '${snapshot.data![index].title}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                        '${snapshot.data![index].description}'),
                                  ),
                                ),
                              );
                            },
                          );
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
