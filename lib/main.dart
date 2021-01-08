/// Flutter code sample for NavigationRail
// This example shows a [NavigationRail] used within a Scaffold with 3
// [NavigationRailDestination]s. The main content is separated by a divider
// (although elevation on the navigation rail can be used instead). The
// `_selectedIndex` is updated by the `onDestinationSelected` callback.
import 'secrets.dart';
import 'utils/calendar_client.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'utils/texttospeech.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  // Google Sign in
  WidgetsFlutterBinding.ensureInitialized();
  await DotEnv().load('.env');
  var _clientID = new ClientId(Secret.getId(), "");
  const _scopes = const [cal.CalendarApi.CalendarScope];
  await clientViaUserConsent(_clientID, _scopes, prompt).then((AuthClient client) async {
    CalendarClient.calendar = cal.CalendarApi(client);
  });

;  runApp(MyApp());
} 

/// This is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

void prompt(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  List<Widget> screens = [Alarm(), Music(), Water(), About()];

  CalendarClient calendarClient = CalendarClient();
  var CalendarData;
  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('H20Clock'),
      ),
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.selected,
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.access_alarm),
                selectedIcon: Icon(Icons.access_alarm),
                label: Text('Alarm'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.library_music),
                selectedIcon: Icon(Icons.library_music),
                label: Text('Music'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.star_border),
                selectedIcon: Icon(Icons.star),
                label: Text('Water'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.book),
                selectedIcon: Icon(Icons.book),
                label: Text('Tasks'),
              ),
            ],
          ),
          VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(
              child: screens[_selectedIndex]
          ),
          // Get Calendar Data
          FloatingActionButton(
            onPressed: () async {
              calendarClient.extract()
                .then((eventData) async {
                  debugPrint(eventData.toString()); 
                
                  // Set calendar events
                  setState(() {
                    CalendarData = eventData;
                  });
                  
                  // Create .wav file & play
                  textToSpeech(eventData,'audio')
                    .then((audiofilepath) async {
                      int response = await advancedPlayer.play(audiofilepath, isLocal: true);
                    })
                    .catchError(
                      (e) => print(e),
                    );
                })
                .catchError(
                  (e) => print(e),
                );
            },
            child: Icon(Icons.navigation),
            backgroundColor: Colors.green,
          )
        ],
      ),
    );
  }
}





//////////////////////////////////////////////////////////////////////////////
class Alarm extends StatefulWidget {
  @override
  _AlarmState createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  TimeOfDay _time = TimeOfDay.now();
  TimeOfDay picked;
  String time = '10:10';

  Future<Null> selectTime(BuildContext context) async {
    picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    setState(() {
      _time = picked;
      print(_time);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Your Alarm!'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: ListTile(
            title: Text(time,
              style: TextStyle(fontSize: 40, color: Colors.indigo)),
            trailing: Icon(Icons.alarm, size:60),
            onTap: () {
              selectTime(context);
              time = '${_time.hour}:${_time.minute}';
            },
          )
        )
      ),
    );
  }
}




//////////////////////////////////////////////////////////////////////////////
class Music extends StatefulWidget {
  @override
  _MusicState createState() => _MusicState();
}

class _MusicState extends State<Music> {
  var _song = 0;
  var songList = ["Pixel Galaxy", "Sunday", "Snailchan Adventure"];

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(12.0),
      child: ListView(
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          ]),
          Text(
            "Choose Your Music!",
            style: TextStyle(
                fontSize: 30, color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          // ListTile(
          //   title: Text(songList[0]),
          //   leading: Radio(
          //     value: 0,
          //     groupValue: _song,
          //     onChanged: (value) {
          //       this.setState((){
          //         _song = value;
          //       });
          //     },
          //   ),
          // ),
          // ListTile(
          //   title: Text(songList[1]),
          //   leading: Radio(
          //     value: 1,
          //     groupValue: _song,
          //     onChanged: (value) {
          //       this.setState((){
          //         _song = value;
          //       });
          //     },
          //   ),
          // ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: songList.length,
            itemBuilder: (BuildContext context, int index) {
              return new ListTile(
                title: Text(songList[index],
                  style: TextStyle(fontSize: 24, color: Colors.indigo)),
                leading: Radio(
                  value: index,
                  groupValue: _song,
                  onChanged: (value) {
                    this.setState(() {
                      _song = value;
                    });
                  },
                ),
              );
            },
          )
        ],
      ),
    );


  }
}

class Water extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      alignment: Alignment.topLeft,
      child: ListView(
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          ]),
          Text(
            "Drink Up!",
            style: TextStyle(
                fontSize: 30, color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}


class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      alignment: Alignment.topLeft,
      child: ListView(
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          ]),
          Text(
            "Plan Your Day!",
            style: TextStyle(
                fontSize: 30, color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}


