import 'package:first_app/pages/listview_categoria_page.dart';
import 'package:flutter/material.dart';
import 'package:to_file/pages/categoriaPage.dart';
import 'package:to_file/pages/homePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage()               // tela inicial do App
    );
  }
}
