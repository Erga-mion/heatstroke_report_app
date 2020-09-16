import 'package:flutter/material.dart';

class AlertFormat{
  int _level;
  String comment;
  String image;

  AlertFormat(int level,){
    this._level = level;

    switch (this._level) {
      case 5:
        this.comment = '5 運動は原則中止';
        this.image = 'number_5.png';
        break;
      case 4:
        this.comment = '4 厳重警戒\n（激しい運動は中止）';
        this.image = 'number_4.png';
        break;
      case 3:
        this.comment = '3 警戒\n（積極的に休憩）';
        this.image = 'number_3.png';
        break;
      case 2:
        this.comment = '2 注意\n（積極的に水分補給）';
        this.image = 'number_2.png';
        break;
      case 1:
        this.comment = '1 ほぼ安全\n（適宜水分補給）';
        this.image = 'number_1.png';
        break;
      default:
    }
  }
}