import 'package:flutter/material.dart';

class AlertFormat{
  int level;
  String comment;
  String image;

  AlertFormat(int level,){
    this.level = level;

    switch (this.level) {
      case 5:
        this.comment = '運動は原則中止';
        this.image = 'number_5.png';
        break;
      case 4:
        this.comment = '厳重警戒（激しい運動は中止）';
        this.image = 'number_4.png';
        break;
      case 3:
        this.comment = '警戒（積極的に休憩）';
        this.image = 'number_3.png';
        break;
      case 2:
        this.comment = '注意（積極的に水分補給）';
        this.image = 'number_2.png';
        break;
      case 1:
        this.comment = 'ほぼ安全（適宜水分補給）';
        this.image = 'number_1.png';
        break;
      default:
    }
  }
}