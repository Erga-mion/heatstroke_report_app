//import 'package:flutter/foundation.dart';

class WeatherFormat{
  final DateTime date;
  final humidity;
  final temp;

  WeatherFormat({this.date, this.humidity, this.temp});

  factory WeatherFormat.fromJson(Map<String, dynamic> json){
    return WeatherFormat(
      date: new DateTime.fromMillisecondsSinceEpoch(json['current']['dt']*1000, isUtc: false),
      humidity: json['current']['humidity'],
      temp: json['current']['temp'],
    );
  }
}