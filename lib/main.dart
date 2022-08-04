import 'package:buscadordegifs/ui/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
    theme: ThemeData(hintColor: Colors.white),
  ));
}

//https://api.giphy.com/v1/gifs/search?api_key=kIJ3mPTyYAvOQsrc2eELx0vYu3PQY9d9&q=dog&limit=25&offset=25&rating=g&lang=pt
