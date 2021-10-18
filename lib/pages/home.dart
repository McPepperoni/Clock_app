import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:world_clock_app/UI/AnalogClock.dart';
import 'package:world_clock_app/services/utilities.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Map data = {};

  DateTime now = DateTime.now();

  int hour;

  bool nameUpdated = false;
  bool isAmPm = false;
  bool menuIsExpanded = false;
  bool colorCycle = false;

  String apm = 'am';

  NetworkImage img = NetworkImage('https://via.placeholder.com/70');

  Color subColor = Colors.deepOrange[900];

  void updateTime() {
    // await data['current'].getTime();
    now = DateTime.now();
    now = now.subtract(now.timeZoneOffset).add(data['current'].utc_offset);

    apm = now.hour < 12 ? 'am' : 'pm';
    hour = now.hour <= 12 ? now.hour : now.hour - 12;

    Utility.isDayTime = now.hour < 19 && now.hour > 5 ? true : false;

    Utility.hour = hour;
    Utility.minute = now.minute;
    Utility.second = now.second;
  }

  void updateName() async {
    var temp = await Utility.getName(Utility.code);
    Utility.name = temp != Utility.name ? temp : Utility.name;
  }

  @override
  void initState() {
    Utility.setStatusBar(Colors.transparent);
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      colorCycle = !colorCycle;
      updateName();
      updateTime();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    Utility.code = data['current'].ISOCode;
    Color bgColor = Colors.white;

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Text(
                'SETTINGS',
                style: TextStyle(fontSize: 30.0, color: Utility.themeColor),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  SwitchListTile(
                    value: isAmPm,
                    subtitle: Text(
                      'Change between 24h or 12h clock',
                      style: TextStyle(
                        color: subColor,
                      ),
                    ),
                    title: Text(
                      '12h mode',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: isAmPm ? Utility.themeColor : Colors.grey[500],
                      ),
                    ),
                    activeColor: Utility.themeColor,
                    onChanged: (bool value) {
                      setState(() {
                        isAmPm = value;
                      });
                    },
                    secondary: Icon(
                      Icons.access_alarm,
                      color: isAmPm ? Utility.themeColor : Colors.grey[500],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      backgroundColor: bgColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
      body: MediaQuery.of(context).orientation == Orientation.portrait
          ? verticalView()
          : horizontalView(),
    );
  }

  Widget verticalView() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: topBar(),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 10.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.15),
            child: Clock(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      isAmPm
                          ? hour.toString().padLeft(2, '0')
                          : now.hour.toString().padLeft(2, '0'),
                      style: TextStyle(
                        color: Utility.themeColor,
                        fontSize: 100.0,
                      ),
                    ),
                    Text(
                      now.minute.toString().padLeft(2, '0'),
                      style: TextStyle(
                        color: Utility.themeColor,
                        fontSize: 100.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10.0,
                ),
                isAmPm
                    ? RotatedBox(
                        child: Text(
                          apm,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 40.0,
                          ),
                        ),
                        quarterTurns: 3,
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ':h',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 40.0,
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Text(
                            ':m',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 40.0,
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
          Spacer(),
          Row(
            children: [
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.grey.withOpacity(.5),
                        spreadRadius: 2,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: getNewButton(),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget horizontalView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: topBar(),
        ),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05),
                child: Clock(),
              ),
            ),
            Expanded(
              flex: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        isAmPm
                            ? hour.toString().padLeft(2, '0')
                            : now.hour.toString().padLeft(2, '0'),
                        style: TextStyle(
                          color: Utility.themeColor,
                          fontSize: 100.0,
                        ),
                      ),
                      Text(
                        now.minute.toString().padLeft(2, '0'),
                        style: TextStyle(
                          color: Utility.themeColor,
                          fontSize: 100.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  isAmPm
                      ? RotatedBox(
                          child: Text(
                            apm,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 40.0,
                            ),
                          ),
                          quarterTurns: 3,
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ':h',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 40.0,
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Text(
                              ':m',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 40.0,
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.grey.withOpacity(.5),
                      spreadRadius: 2,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: getNewButton(),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.height * 0.05)
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        )
      ],
    );
  }

  Row topBar() {
    return Row(
      children: [
        Column(
          children: [
            Text(
              '${data['current'].location}',
              style: TextStyle(
                color: Utility.themeColor,
                fontSize: 30.0,
              ),
            ),
            Utility.name == 'Unknown'
                ? countryNamePlaceholder()
                : countryName(),
          ],
        ),
        SizedBox(
          width: 20.0,
        ),
        Container(
          child: FutureBuilder(
            future: Utility.getNetworkImg(data['current'].ISOCode),
            builder: (context, snapshot) {
              if (!nameUpdated) {
                if (snapshot.connectionState == ConnectionState.done) {
                  img = snapshot.data;
                  nameUpdated = !nameUpdated;
                } else
                  return AnimatedContainer(
                    width: 10.0,
                    height: 10.0,
                    duration: Duration(milliseconds: 250),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorCycle ? Colors.grey[300] : Colors.grey[400],
                    ),
                  );
              }

              return CircleAvatar(
                radius: 20.0,
                backgroundImage: img,
                backgroundColor: Colors.transparent,
              );
            },
          ),
        ),
        Spacer(),
        Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 5.0,
            ),
            child: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                _scaffoldKey.currentState.openDrawer();
              },
            ))
      ],
    );
  }

  Widget getNewButton() {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Utility.themeColor,
      child: IconButton(
        onPressed: () {
          Navigator.pushNamed(context, '/location');
        },
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  //Country name
  Text countryName() {
    return Text(
      Utility.name,
      style: TextStyle(
        color: subColor,
        fontSize: 20.0,
      ),
    );
  }

  Widget countryNamePlaceholder() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: colorCycle ? Colors.grey[300] : Colors.grey[400],
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Text(
        Utility.name,
        style: TextStyle(
          color: Colors.transparent,
          fontSize: 20.0,
        ),
      ),
    );
  }
  //
}
