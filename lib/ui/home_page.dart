
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network("https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Pesquise aqui",
                labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.2),
                  ),
                border: OutlineInputBorder()
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.0
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
              child: FutureBuilder(
                future: _getSearch(),
                builder: (context, snapshot) {
                  switch(snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      );
                     default:
                       if(snapshot.hasError) return Container();
                       else return _createGifTable(context, snapshot);
                  }
                }
              ),
          ),
        ],
      ),
    );
  }
}
