import 'package:flutter/material.dart';
import 'package:world_clock_app/services/worldclock.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String time = 'Looking...';

  void getWorldTime() async {
    worldClock instance = worldClock(url: 'lat=52.5244lng=13.4105');

    await instance.getTime();

    print(instance.ISOCode);

    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'current': instance,
    });
  }

  @override
  void initState() {
    super.initState();
    getWorldTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: SpinKitWave(
          color: Colors.indigo[900],
          size: 50.0,
        ),
      )),
    );
  }
}
