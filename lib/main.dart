import 'package:flutter/material.dart';
import 'package:heatstroke_report_app/weather_format.dart';
import 'package:heatstroke_report_app/alert_format.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(
    title: 'Heatstroke report app',
    theme: new ThemeData(
        primarySwatch: Colors.orange,
      ),
    // Start the app with the "/" named route. In this case, the app starts
    // on the MainScreen widget.
    initialRoute: '/',
    routes: {
      // When navigating to the "/" route, build the MainScreen widget.
      '/': (context) => MainScreen(),
      // When navigating to the "/Setting" route, build the SettingScreen widget.
      '/setting': (context) => SettingScreen(),
      '/area': (context) => AreaScreen(),
    },
  ));
}



class MainScreen extends StatelessWidget {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('メイン画面',
          style: optionStyle,),
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          HeatstrokeInfo(),

        ],
      ),
    );
  }
}


class HeatstrokeInfo extends StatefulWidget {
  @override
  _HeatstrokeInfoState createState() => _HeatstrokeInfoState();
}

class _HeatstrokeInfoState extends State<HeatstrokeInfo> {
  bool isLoading = false;
  WeatherFormat weatherFormat;
  AlertFormat alertFormat;
  double wbgt;

  @override
  void initState(){
    super.initState();

    loadWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Center(child: FlatButton(
            child: Text('若松区',style: TextStyle(fontSize: 40),),
            onPressed: () {
              // Navigate to the Setting screen using a named route.
              Navigator.pushNamed(context, '/area');
            },
          )
          ),
          
          Center(child: FlatButton(
            child: Text('${new DateFormat.Hm().format(weatherFormat.date)} 更新　🔄',style: TextStyle(fontSize: 40),),
            onPressed: (){
              loadWeather();
            }
          )
          ),


          Container(
            padding: const EdgeInsets.all(20),
            //alignment: Alignment.bottomCenter,
            //color: Colors.orange[50],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.asset('images/${alertFormat.image}', fit: BoxFit.contain),
                Text('危険度${alertFormat.comment}\n',textAlign: TextAlign.center,style: TextStyle(fontSize: 40),),
                Text('温度 ${weatherFormat.temp.toString()}℃ \n湿度 ${weatherFormat.humidity.toString()}%',style: TextStyle(fontSize: 40),),
              ],
            )
          ),
        
          Container(
            padding: const EdgeInsets.all(8),
            //alignment: Alignment.bottomCenter,
            //color: Colors.orange[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RaisedButton(
                  child: Text('🔄 更新',style: TextStyle(fontSize: 40),),
                  onPressed: () {
                    loadWeather();
                  },
                ),

                RaisedButton(
                  child: Text('地域設定',style: TextStyle(fontSize: 40),),
                  onPressed: () {
                    // Navigate to the Setting screen using a named route.
                    Navigator.pushNamed(context, '/area');
                  },
                ),
              ],
            )
          ),
        
        ],
      ),      
    );
  }

  loadWeather() async{
    setState(() {
      isLoading = true;
    });

    final lat = 33.8914151;
    final lon = 130.707071;
    final weatherResponse = await http.get(
      'https://api.openweathermap.org/data/2.5/onecall?lat=${lat.toString()}&lon=${lon.toString()}&exclude=minutely,hourly,daily&units=metric&APPID='
    );

    if(weatherResponse.statusCode == 200){
      return setState(() {
        weatherFormat = new WeatherFormat.fromJson(jsonDecode(weatherResponse.body));
        outdoorWbgt();
        isLoading = false;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  outdoorWbgt(){
    wbgt = 0.735 * weatherFormat.temp + 0.0374 * weatherFormat.humidity + 0.00292 * weatherFormat.temp * weatherFormat.humidity - 4.064;
    if(wbgt>=31){alertFormat = new AlertFormat(5);}
    else if(wbgt >= 28 && wbgt < 31){alertFormat = new AlertFormat(4);}
    else if(wbgt >= 25 && wbgt < 28){alertFormat = new AlertFormat(3);}
    else if(wbgt >= 21 && wbgt < 25){alertFormat = new AlertFormat(2);}
    else if(wbgt < 21){alertFormat = new AlertFormat(1);}
  }

}


class SettingScreen extends StatelessWidget {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("設定",
          style: optionStyle,),
      ),

      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.pin_drop, size: 36.0,),
            title: Text('地域設定', style: TextStyle(fontSize: 30),),
            onTap: (){Navigator.pushNamed(context, '/area');
            },
          ),
        ],
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }
}


class AreaScreen extends StatelessWidget {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("地域・プリセット設定",
          style: optionStyle,),
      ),

      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.gps_fixed, size: 36.0,),
            title: Text('GPSで現在地を探す', style: TextStyle(fontSize: 30),),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.not_listed_location, size: 36.0,),
            title: Text('地域を探す', style: TextStyle(fontSize: 30),),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.person_pin_circle, size: 36.0,),
            title: Text('プリセットから選ぶ', style: TextStyle(fontSize: 30),),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.edit_location, size: 36.0,),
            title: Text('プリセットを編集する', style: TextStyle(fontSize: 30),),
            onTap: (){},
          ),
        ],
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }
}
