import 'package:flutter/material.dart';

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
  final UpdatedTime = 1200;
  final CurrentArea = "北九州市小倉南区曽根";
  final DangerLevel = "4";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('メイン画面',
          style: optionStyle,),
      ),

      body: Column(
        children: [

          Center(child: FlatButton(
            child: Text('Area Name: $CurrentArea',style: TextStyle(fontSize: 20),),
            onPressed: () {
              // Navigate to the Setting screen using a named route.
              Navigator.pushNamed(context, '/area');
            },
          )
          ),
          
          Center(child: FlatButton(
            child: Text('Updated Time: $UpdatedTime 現在',style: TextStyle(fontSize: 25),),
            onPressed: () {
              // Navigate to the Setting screen using a named route.
              //Navigator.pushNamed(context, '/area');
            },
          )
          ),


          Container(
            padding: const EdgeInsets.all(20),
            //alignment: Alignment.bottomCenter,
            color: Colors.orange[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.asset('images/necchusyou_shitsunai.png', scale: 3.8,),
                Text('危険度を表示: $DangerLevel',style: TextStyle(fontSize: 20),),
              ],
            )
          ),


          Container(
            padding: const EdgeInsets.all(20),
            //alignment: Alignment.bottomCenter,
            color: Colors.orange[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RaisedButton(
                  child: Text('詳細データ',style: TextStyle(fontSize: 20),),
                  onPressed: () {
                    // Navigate to the Setting screen using a named route.
                    //Navigator.pushNamed(context, '/Setting');
                  },
                ),

                RaisedButton(
                  child: Text('設定',style: TextStyle(fontSize: 20),),
                  onPressed: () {
                    // Navigate to the Setting screen using a named route.
                    Navigator.pushNamed(context, '/setting');
                  },
                ),
              ],
            )
          ),

        ],
      ),
    );
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


class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Material App"),
      ),
      body: new Center(
        child: new Text(
              'Hello World',
            ),
      ),
    );
  }
}