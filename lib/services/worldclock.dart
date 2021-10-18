import 'package:http/http.dart';
import 'dart:convert';
import 'package:world_clock_app/services/utilities.dart';

class worldClock {
  static String path = 'http://10.0.2.2:8000';

  Duration utc_offset;

  String location;
  String url;
  String ISOCode; //api endpoint

  worldClock({this.url});

  Future<void> getTime() async {
    try {
      Response response = await get(Uri.parse('$path/CT/$url'));

      List data = jsonDecode(response.body);
      print(data);
      utc_offset = Utility.DurationParse(data[0]['utc_offset']);
      location = data[0]['name'];
      ISOCode = data[0]['country'];
    } catch (e) {
      print('Error encountered: $e');

      utc_offset = Duration(hours: 0, minutes: 0, seconds: 0);
      location = 'Unknown location';
      ISOCode = 'Unknown';
    }
  }
}
