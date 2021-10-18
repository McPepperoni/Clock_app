import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Utility {
  static Color themeColor = Color(0xFF001F46);

  static String name = 'Unknown';
  static String code = 'Unknown';

  static int hour = 0;
  static int minute = 0;
  static int second = 0;

  static bool isDayTime = true;

  static void setStatusBar(bgColor) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: bgColor,
      ),
    );
  }

  static Duration DurationParse(String duration) {
    List<String> parts = duration.split(':');
    return Duration(
        hours: int.parse(parts[0]),
        minutes: int.parse(parts[1]),
        seconds: int.parse(parts[2]));
  }

  static Future<NetworkImage> getNetworkImg(String code) async {
    NetworkImage img;
    try {
      img = NetworkImage('https://www.countryflags.io/$code/flat/64.png');
    } catch (e) {
      img = NetworkImage('https://via.placeholder.com/70');
    }

    return img;
  }

  static Future<String> getName(String code) async {
    String name;
    try {
      Response response = await get(
          Uri.parse('https://restcountries.com/v3/alpha?codes=$code'));

      List result = jsonDecode(response.body);
      name = result[0]['name']['common'];
    } catch (e) {
      name = 'Unknown';
    }
    return name;
  }
}
