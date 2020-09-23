import 'package:flutter/material.dart';
import 'package:heatstroke_report_app/weather_format.dart';
import 'package:heatstroke_report_app/alert_format.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
      TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('熱中症危険度',
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
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool isLoading = false;
  WeatherFormat weatherFormat;
  AlertFormat alertFormat;
  Position userLocation;
  Placemark userPlacemark;
  double wbgt;

  @override
  void initState(){
    super.initState();

    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    
    loadWeather();
    Timer.periodic(Duration(minutes: 1), (timer) {loadWeather();});
  }

  Future _showNotification() async {
    var scheduledNotificationDateTime = new DateTime.now().add(new Duration(seconds: 5));
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(0, '[${DateFormat.Hm().format(weatherFormat.date)}現在]${alertFormat.comment}',
    'こまめな水分補給を忘れずに。', scheduledNotificationDateTime, platformChannelSpecifics);
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: FlatButton(
            child: Text('更新:${DateFormat.Md().format(weatherFormat.date)} ${new DateFormat.Hm().format(weatherFormat.date)}\n現在地:${userPlacemark.locality}',style: TextStyle(fontSize: 35),),
            onPressed: () {
              // Navigate to the Setting screen using a named route.
              Navigator.pushNamed(context, '/area');
            },
            )
          ),
          
          /*Align(
            alignment: Alignment.topLeft,
            child: FlatButton(
            child: Text('${new DateFormat.Hm().format(weatherFormat.date)}    現在',style: TextStyle(fontSize: 40),),
            onPressed: (){
              loadWeather();
            }
            )
          ),*/


          Container(
            padding: const EdgeInsets.all(20),
            //alignment: Alignment.bottomCenter,
            //color: Colors.orange[50],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.asset('images/${alertFormat.image}', fit: BoxFit.contain),
                Text('${alertFormat.comment}',textAlign: TextAlign.left,style: TextStyle(fontSize: 35),),
                Text('温度 ${weatherFormat.temp.toString()}℃ 湿度 ${weatherFormat.humidity.toString()}%',style: TextStyle(fontSize: 30),),
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
                  child: Text('1',style: TextStyle(fontSize: 60, color: Colors.white),),
                  color: Colors.orange,                 
                  onPressed: () {
                    
                  },
                ),

                RaisedButton(
                  child: Text('2',style: TextStyle(fontSize: 60, color: Colors.white),),
                  color: Colors.orange,                 
                  onPressed: () {
                    
                  },
                ),

                RaisedButton(
                  child: Text('3',style: TextStyle(fontSize: 60, color: Colors.white),),
                  color: Colors.orange,                
                  onPressed: () {
                    
                  },
                ),

              ],
            )
          ),

          Container(
            padding: const EdgeInsets.all(20),
            //alignment: Alignment.bottomCenter,
            //color: Colors.orange[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RaisedButton(
                  child: Text('更新(開始)',style: TextStyle(fontSize: 30, color: Colors.white),),
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),                  
                  onPressed: () {
                    loadWeather();
                  },
                ),

                /*RaisedButton(
                  child: Text('自動更新停止',style: TextStyle(fontSize: 30, color: Colors.white),),
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),                  
                  onPressed: () {
                    setState(() {
                      _timer.cancel();
                    });                    
                  },
                ),*/
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
    await getLocation();
    await getPlacemark();
    //final lat = 33.8914151;
    //final lon = 130.707071;
    final lat = userLocation.latitude;
    final lon = userLocation.longitude;
    // Warning!! Remove APPID before 'git add' !!!
    final weatherResponse = await http.get(
      'https://api.openweathermap.org/data/2.5/onecall?lat=${lat.toString()}&lon=${lon.toString()}&exclude=minutely,hourly,daily&units=metric&APPID='
    );

    if(weatherResponse.statusCode == 200){
      return setState(() {
        weatherFormat = new WeatherFormat.fromJson(jsonDecode(weatherResponse.body));
        outdoorWbgt();
        _showNotification();
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

  Future<void> getLocation() async {
    Position currentLocation;
    try {
      currentLocation = await getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
    }
    catch(e){
      currentLocation = null;      
    }
    userLocation = currentLocation;
    print(userLocation);
  }

  Future<void> getPlacemark() async{
    List<Placemark> placemarks = await placemarkFromCoordinates(userLocation.latitude, userLocation.longitude, localeIdentifier: 'ja');
    if(placemarks != null && placemarks.isNotEmpty){
      userPlacemark = placemarks[0];
      print(userPlacemark);
    }
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
            leading: Icon(Icons.gps_fixed, size: 40.0,),
            title: Text('GPSで現在地を探す', style: TextStyle(fontSize: 40),),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.not_listed_location, size: 40.0,),
            title: Text('地域を探す', style: TextStyle(fontSize: 40),),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.person_pin_circle, size: 40.0,),
            title: Text('プリセットから選ぶ', style: TextStyle(fontSize: 40),),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.edit_location, size: 40.0,),
            title: Text('プリセットを編集する', style: TextStyle(fontSize: 40),),
            onTap: (){},
          ),
        ],
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }
}
