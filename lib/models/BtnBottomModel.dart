import 'package:flutter/cupertino.dart';

class BtnBottomModel {
  IconData? icon;
  late String imageString;
  late String name;
  late int index;
  late Color textColor;
  late Color borderColor;
  late Color bgColor;

  BtnBottomModel(IconData? icon, String imageString, String name, int index, Color textColor, Color borderColor, Color bgColor){
    this.icon = icon;
    this.imageString = imageString;
    this.name = name;
    this.index = index;
    this.textColor = textColor;
    this.borderColor = borderColor;
    this.bgColor = bgColor;
  }
}