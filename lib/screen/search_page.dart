import 'package:newspaper_app/const.dart';
import 'package:http/http.dart' as http;
import 'package:newspaper_app/customhttp.dart';
import 'package:newspaper_app/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// ignore: depend_on_referenced_packages
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  List<Articles> searchList = [];
  FocusNode focusNode = FocusNode();
  List<String> searchKeyword = [
    "World",
    "Sports",
    "Football",
    "Cricket",
    "Entertainment",
    "Fashion",
    "Weather",
    "Politics",
    "             ",
    "more...",
  ];

  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: isloading == true,
        blur: 0.5,
        opacity: 0.5,
        child: Scaffold(
          body: Container(
            /*
            // Use a BoxDecoration to set the gradient background
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orange,
                  Colors.amber,
                  Colors.lime,
                  //Colors.lightGreen,
                  Colors.amber,
                  //Colors.lightGreen,
                  Colors.lime,
                  Colors.amber,
                  Colors.orange
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            */

            padding: EdgeInsets.all(22),
            child: SingleChildScrollView(
                child: Column(
              children: [
                SizedBox(
                  height: 60,
                  child: TextField(
                    focusNode: focusNode,
                    controller: searchController,
                    decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 3, color: Colors.orange),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 4, color: Colors.orange),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              searchList = [];
                              searchController.clear();

                              setState(() {});
                            },
                            icon: Icon(Icons.close))),
                    onEditingComplete: () async {
                      searchList = await CustomHttp()
                          .fetchSearchData(query: searchController.text);

                      setState(() {});
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                searchList.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SizedBox(
                          height: 100,
                          child: MasonryGridView.count(
                            crossAxisCount: 4,
                            mainAxisSpacing: 20,
                            itemCount: searchKeyword.length,
                            crossAxisSpacing: 4,
                            itemBuilder: (context, index) {
                              return Container(
                                child: InkWell(
                                  onTap: () async {
                                    setState(() {
                                      isloading = true;
                                    });
                                    searchController.text =
                                        searchKeyword[index];
                                    searchList = await CustomHttp()
                                        .fetchSearchData(
                                            query: searchKeyword[index]);
                                    setState(() {
                                      isloading = false;
                                    });
                                  },
                                  child: Text("${searchKeyword[index]}"),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 0,
                      ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: searchList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1,
                            color: Color.fromARGB(255, 102, 102, 101)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.orange,
                              Colors.amber,
                              Colors.lime,
                              //Colors.lightGreen,
                              Colors.amber,
                              //Colors.lightGreen,
                              Colors.lime,
                              Colors.amber,
                              Colors.orange
                            ],
                            //begin: Alignment.topCenter,
                            //end: Alignment.bottomCenter,
                          ),
                        ),
                        child: ListTile(
                          leading:
                              Image.network("${searchList[index].urlToImage}"),
                          title: Text("${searchList[index].title}"),
                          subtitle: Text(
                            "${searchList[index].description}",
                            style: myStyle(14, Colors.black54),
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            )),
          ),
        ),
      ),
    );
  }
}
