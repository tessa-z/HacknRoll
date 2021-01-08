/// Flutter code sample for NavigationRail

// This example shows a [NavigationRail] used within a Scaffold with 3
// [NavigationRailDestination]s. The main content is separated by a divider
// (although elevation on the navigation rail can be used instead). The
// `_selectedIndex` is updated by the `onDestinationSelected` callback.

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'helperFunctions.dart' as helper;

void main() => runApp(MyApp());

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

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  List<Widget> screens = [Clock(), Music(), Water(), About(), Bluetooth()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Morning Pal'),
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
              NavigationRailDestination(
                icon: Icon(Icons.bluetooth),
                selectedIcon: Icon(Icons.bluetooth),
                label: Text('Bluetooth Test'),
              ),
            ],
          ),
          VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(child: screens[_selectedIndex]),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////

class Clock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          CurvedListItem(
            title: '06:00',
            color: Colors.indigo[900],
            nextColor: Colors.indigo[800],
          ),
          CurvedListItem(
            title: '06:30',
            color: Colors.indigo[800],
            nextColor: Colors.indigo[700],
          ),
          CurvedListItem(
            title: '07:00',
            color: Colors.indigo[700],
            nextColor: Colors.indigo[600],
          ),
          CurvedListItem(
            title: '07:30',
            color: Colors.indigo[600],
            nextColor: Colors.indigo[500],
          ),
          CurvedListItem(
            title: '08:00',
            color: Colors.indigo[500],
            nextColor: Colors.indigo[400],
          ),
          CurvedListItem(
            title: '08:30',
            color: Colors.indigo[400],
            nextColor: Colors.blue[500],
          ),
          CurvedListItem(
            title: '09:00',
            color: Colors.blue[500],
            nextColor: Colors.blue[400],
          ),
          CurvedListItem(
            title: '09:30',
            color: Colors.blue[400],
            nextColor: Colors.blue[300],
          ),
          CurvedListItem(
            title: '10:00',
            color: Colors.blue[300],
            nextColor: Colors.blue[200],
          ),
        ],
      ),
    );
  }
}

class CurvedListItem extends StatelessWidget {
  const CurvedListItem({
    this.title,
    this.icon,
    this.people,
    this.color,
    this.nextColor,
  });

  final String title;
  final String people;
  final IconData icon;
  final Color color;
  final Color nextColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: nextColor,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(0.0),
          ),
          border: Border.all(width: 3.0),
        ),
        padding: const EdgeInsets.only(
          left: 60,
          top: 30.0,
          bottom: 40,
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              Row(),
            ]),
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
          Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[]),
          Text(
            "Choose Your Music!",
            style: TextStyle(
                fontSize: 30, color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: songList.length,
            itemBuilder: (BuildContext context, int index) {
              return new ListTile(
                title: Text(songList[index]),
                leading: Radio(
                  value: index,
                  groupValue: _song,
                  onChanged: (value) {
                    setState(() {
                      _song = value;
                    });
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class Water extends StatefulWidget {
  @override
  _WaterState createState() => _WaterState();
}

class _WaterState extends State<Water> {
  var _waterVolume = 0;
  final _counterFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      alignment: Alignment.topLeft,
      child: ListView(
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[]),
          Text(
            "Drink Up!",
            style: TextStyle(
                fontSize: 30, color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          Form(
              key: _counterFormKey,
              child: Column(children: <Widget>[
                // Add TextFormFields and ElevatedButton here.
                Text('How much water will wake you up tomorrow?'),
                TextFormField(
                  // The validator receives the text that the user has entered.
                  decoration: const InputDecoration(
                    hintText: 'Recommended 650ml',
                    labelText: 'Volume (ml)'
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Drink up or else';
                    }
                    if (!helper.isNumeric(value)) {
                      return ('You want to drink $value?');
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, otherwise false.
                    if (_counterFormKey.currentState.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.

                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Sending data')));
                    }
                  },
                  child: Text('Confirm'),
                )
              ]))
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
          Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[]),
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

class Bluetooth extends StatefulWidget {
  @override
  _BluetoothState createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth> {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = new List<BluetoothDevice>();
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();
  final textController = TextEditingController();
  BluetoothDevice connectedDevice;
  List<BluetoothService> bluetoothServices;

  _showDeviceTolist(final BluetoothDevice device) {
    if (!devicesList.contains(device)) {
      setState(() {
        devicesList.add(device);
      });
    }
  }

  @override
  void initState() {
    // Start scanning
    flutterBlue.startScan(timeout: Duration(seconds: 4));

    // Listen to scan results
    flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        _showDeviceTolist(r.device);
      }
    });

    // Stop scanning
    flutterBlue.stopScan();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(12.0),
      alignment: Alignment.topLeft,
      child: ListView(
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[]),
          Text(
            "Bluetooth Connection",
            style: TextStyle(
                fontSize: 30, color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: devicesList.length,
            itemBuilder: (BuildContext context, int index) {
              return new ListTile(
                title: Text(devicesList[index].toString())
                );
            },
          ),
        ],
      ),
    );
  }
}
