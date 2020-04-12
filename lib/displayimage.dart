import 'package:flutter/material.dart';

class DisplayImage extends StatelessWidget {
  String url;
 DisplayImage(this.url);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
home: Scaffold(
 body:Container(child: Image.network(url),)
),
    );
  }
}