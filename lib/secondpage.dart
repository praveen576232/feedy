import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutterapppp/homepage.dart';
import 'package:flutterapppp/mapview.dart';

import 'package:connectivity/connectivity.dart';

void main()=>runApp(Botomnavigation());
class Botomnavigation extends StatefulWidget
{
  @override
  _BotomnavigationState createState() => _BotomnavigationState();
}

class _BotomnavigationState extends State<Botomnavigation> with SingleTickerProviderStateMixin{
 
  int curentstate=0;
final tab=[
  MyOneApp(),
  MyGoogleMap()
];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return 
         MaterialApp(
           debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: tab[curentstate],
          bottomNavigationBar:BottomNavigationBar(
            currentIndex: curentstate,
             type: BottomNavigationBarType.fixed,
           
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text("Home")
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.directions),
                title: Text("Near me"),
               

              )
            ],
            onTap: (index)
            {
              setState(() {
               curentstate=index; 
              });
            },
          ),
          ),
      
      );
    
      
  }
}