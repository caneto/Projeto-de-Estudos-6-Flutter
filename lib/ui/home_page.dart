import 'dart:async';
import 'dart:convert';

import 'package:buscadordegifs/ui/gif_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

var url1 = Uri.parse('https://api.giphy.com/v1/gifs/trending?api_key=kIJ3mPTyYAvOQsrc2eELx0vYu3PQY9d9&limit=25&rating=g');
var url2 = 'https://api.giphy.com/v1/gifs/search?api_key=kIJ3mPTyYAvOQsrc2eELx0vYu3PQY9d9&q=';
var url3 = '&limit=19&offset=';
var url4 = '&rating=g&lang=pt';

class _HomePageState extends State<HomePage> {

  String? _search;

  int _offset = 0;

  Future<Map> _getSearch() async {
    http.Response response;

    if(_search == null || _search!.isEmpty) {
      response = await http.get(url1);
    } else {
      print(_offset.toString());

      String urlx = url2 + _search! + url3 + _offset.toString() + url4;

      print(urlx);

      Uri url = Uri.parse(urlx);
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
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  _offset=0;
                });
              },
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

  int _setCount(List data) {
    if(_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing : 10.0,
        ),
        itemCount: _setCount(snapshot.data["data"]),
        itemBuilder: (context, index) {
          if(_search == null || index < snapshot.data['data'].length)
            return GestureDetector(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                height: 300.0,
                fit: BoxFit.cover,
              ),
              onTap: () {
                Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => GifPage(snapshot.data['data'][index]))
                );
              },
              onLongPress: () {
                Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
              },
            );
          else
            return Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.add, color: Colors.white, size: 70.0,),
                    Text("Carregar mais...",
                      style: TextStyle(color: Colors.white, fontSize: 22.0),)
                  ],
                ),
                onTap: () {
                  setState(() {
                    _offset += 19;
                  });
                },
              ),
            );
        }
    );
  }
}
