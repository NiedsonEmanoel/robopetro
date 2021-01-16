import 'package:flutter/material.dart';
import 'main.dart';

class UIcolor {
 Color kBackgroundColor = Color(0xFFFEFEFE); //black87
 Color kTitleTextColor = Color(0xFF303030); // branco
 Color kassandra = Colors.white;
 Color kBodyTextColor = Color(0xFF4B4B4B); // branco
 Color cBOX = Colors.white;

 UIcolor(int s) {
   switch(s) {
     case 1:
       kBackgroundColor = Color(0xFFFEFEFE); //black87
       kTitleTextColor = Color(0xFF303030); // branco
       kassandra = Colors.white;
       kBodyTextColor = Color(0xFF4B4B4B); // branco
       cBOX = Colors.white;
       break;

     case 0:
       kBackgroundColor = Colors.black87; //black87
       kTitleTextColor = Colors.white; // branco
       kassandra = Colors.pinkAccent;
       kBodyTextColor = Colors.white; // branco
       cBOX = Colors.black12;
       break;
   }
 }
}