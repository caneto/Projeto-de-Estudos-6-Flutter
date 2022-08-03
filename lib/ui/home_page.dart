import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

var url1 = Uri.parse('https://api.giphy.com/v1/gifs/trending?api_key=kIJ3mPTyYAvOQsrc2eELx0vYu3PQY9d9&limit=25&rating=g');
var url2 = 'https://api.giphy.com/v1/gifs/search?api_key=kIJ3mPTyYAvOQsrc2eELx0vYu3PQY9d9&q=xxxx&limit=25&offset=xx&rating=g&lang=pt';

class _HomePageState extends State<HomePage> {

  String? _search;

  int _offset = 0;

  Future<Map> _getSearch() async {
    http.Response response;

    if(_search == null) {
      response = await http.get(url1);
    } else {
      url2.replaceAll("xxxx", _search!);
      url2.replaceAll("xx", _offset.toString());

      Uri url = Uri.parse(url2);
      response = await http.get(url);
    }

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _getSearch().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
