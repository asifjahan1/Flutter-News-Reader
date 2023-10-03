import 'dart:convert';
// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:newspaper_app/model/model.dart';
import 'package:http/http.dart' as http;
import 'package:newspaper_app/const.dart';

class CustomHttp {
  Future<List<Articles>> fetchAllNewsData(
      {required int pageNo, required String sortBy}) async {
    List<Articles> allNewsData = [];
    Articles articles;

    var response = await http.get(Uri.parse(
      // ignore: unnecessary_brace_in_string_interps
        "${baseUrl}&q=bitcoin&page=$pageNo&pageSize=10&sortBy=$sortBy&apiKey=$token"));
    print("response is ${response.body}");

    var data = jsonDecode(response.body);
    for (var i in data["articles"]) {
      articles = Articles.fromJson(i);
      allNewsData.add(articles);
    }

    return allNewsData;
  }

  Future<List<Articles>> fetchSearchData({required String query}) async {
    List<Articles> allNewsData = [];
    Articles articles;

    var response = await http.get(Uri.parse(
        "https://newsapi.org/v2/everything?q=$query&apiKey=f1f697fbcb884fea97366c2bf58fc673"));
    print("response is ${response.body}");

    var data = jsonDecode(response.body);
    for (var i in data["articles"]) {
      articles = Articles.fromJson(i);
      allNewsData.add(articles);
    }

    return allNewsData;
  }
}

  //fetchSearchData({required String query}) {}

//  fechSearchData({required String query}) {}

