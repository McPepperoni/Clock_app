import 'dart:convert';

import 'package:http/http.dart';
import 'package:world_clock_app/services/utilities.dart';

import 'package:world_clock_app/services/worldclock.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class ChooseLocation extends StatefulWidget {
  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  final TextEditingController _coutryTextControler = TextEditingController();
  final TextEditingController _cityTextControler = TextEditingController();
  final ScrollController _scrollViewController = ScrollController();

  List searchResult;

  bool _showAppbar = true;
  bool isScrollingDown = false;
  bool foundResult = false;
  bool generateNewData = true;

  int openIndex = -1;

  Color textColor;
  Color bgColor = Color(0xFF001F46);
  Color cardColor;

  String searchQuery;

  Map data = {};

  Widget isOpening;

  void getLocation(index) async {
    await data['cities'][index].getTime();
    Navigator.pop(context, {
      'current': data['cities'][index],
      'cities': data['cities'],
    });
  }

  void getSearch() async {
    if (searchQuery !=
        '${_coutryTextControler.text}-${_cityTextControler.text}') {
      try {
        List data;
        print(
            'country: ${_coutryTextControler.text} city: ${_cityTextControler.text}');
        if (_coutryTextControler.text == "" && _cityTextControler.text != "") {
          Response response = await get(
              Uri.parse('${worldClock.path}/CT/${_cityTextControler.text}'));
          data = jsonDecode(response.body);
        } else if (_coutryTextControler.text != "" &&
            _cityTextControler.text == "") {
          Response response = await get(
              Uri.parse('${worldClock.path}/CN/${_coutryTextControler.text}'));
          data = jsonDecode(response.body);
        } else if (_coutryTextControler.text != "" &&
            _cityTextControler.text != "") {
          Response response = await get(Uri.parse(
              '${worldClock.path}/CN/${_coutryTextControler.text}/${_cityTextControler.text}'));
          data = jsonDecode(response.body);
        }
        print(data);
        if (data != null) {
          data.sort((m1, m2) {
            var r = m1["num"].compareTo(m2["num"]);
            if (r != 0) return r;
            return m1["num"].compareTo(m2["num"]);
          });

          foundResult = true;
          searchResult = List.from(data.reversed);
        } else {
          foundResult = false;
        }
      } catch (e) {
        print(e);
        foundResult = false;
      }

      searchQuery = '${_coutryTextControler.text}-${_cityTextControler.text}';

      setState(() {});
    }
  }

  Future<List> getCities(String code) async {
    try {
      Response response = await get(Uri.parse('${worldClock.path}/C/$code'))
          .timeout(Duration(seconds: 10));

      return jsonDecode(response.body);
    } catch (e) {
      return null;
    }
  }

  NetworkImage getImage(String code) {
    NetworkImage img;
    try {
      img = NetworkImage('https://www.countryflags.io/$code/flat/64.png');
    } catch (e) {
      img = NetworkImage('https://via.placeholder.com/70');
    }

    return img;
  }

  Future<String> getName(String code) async {
    String name;
    try {
      Response response =
          await get(Uri.parse('https://restcountries.com/v3/alpha?codes=$code'))
              .timeout(Duration(seconds: 10));

      List data = jsonDecode(response.body);
      name = '${data[0]['name']['common']}';
    } catch (e) {
      name = 'Cannot get country name';
    }

    return name;
  }

  void _scrollingHandler() {
    if (_scrollViewController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (!isScrollingDown) {
        isScrollingDown = true;
        _showAppbar = false;
        setState(() {});
      }
    }
    if (_scrollViewController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (isScrollingDown) {
        isScrollingDown = false;
        _showAppbar = true;
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    super.dispose();

    _scrollViewController.dispose();
    _coutryTextControler.dispose();
    _cityTextControler.dispose();
  }

  @override
  void initState() {
    Utility.setStatusBar(Colors.transparent);

    _coutryTextControler.addListener(getSearch);
    _cityTextControler.addListener(getSearch);

    _scrollViewController.addListener(_scrollingHandler);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: Utility.themeColor,
          elevation: 0.0,
        ),
      ),
      backgroundColor: Colors.white,
      body: MediaQuery.of(context).orientation == Orientation.portrait
          ? verticalView()
          : horizontalView(),
    );
  }

  Widget verticalView() {
    return Container(
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SingleChildScrollView(
              controller: _scrollViewController,
              clipBehavior: Clip.none,
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: .0, horizontal: 0.0),
                        child: Text(
                          'History',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Spacer(),
                      OutlinedButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            Icon(
                              Icons.dangerous_outlined,
                              color: Colors.grey[500],
                            ),
                            SizedBox(
                              width: 2.0,
                            ),
                            Text(
                              'Delete history',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  backgroundText('No history found! @.@'),
                  headerNote('Search result'),
                  foundResult
                      ? resultList()
                      : backgroundText(
                          'Search returns no result! @.@',
                        ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: _showAppbar || !foundResult ? 100 : 20,
            child: searchBar(),
          ),
        ],
      ),
    );
  }

  Widget horizontalView() {
    return Container(
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SingleChildScrollView(
              controller: _scrollViewController,
              clipBehavior: Clip.none,
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: .0, horizontal: 0.0),
                        child: Text(
                          'History',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Spacer(),
                      OutlinedButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            Icon(
                              Icons.dangerous_outlined,
                              color: Colors.grey[500],
                            ),
                            SizedBox(
                              width: 2.0,
                            ),
                            Text(
                              'Delete history',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  backgroundText('No history found! @.@'),
                  headerNote('Search result'),
                  foundResult
                      ? resultList()
                      : backgroundText(
                          'Search returns no result! @.@',
                        ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: _showAppbar || !foundResult ? 100 : 45,
            child: searchBar(),
          ),
        ],
      ),
    );
  }

  Widget backgroundText(String message, {double fontSize}) {
    fontSize ??= 20.0;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Text(
        message,
        style: TextStyle(fontSize: fontSize, color: Colors.black26),
      ),
    );
  }

  Widget resultList() {
    return ExpansionPanelList.radio(
        dividerColor: Color(0xFF001F46),
        elevation: 0.0,
        children: searchResult.map(
          (item) {
            return ExpansionPanelRadio(
              value: item,
              headerBuilder: (context, isExpanded) {
                if (isExpanded) {
                  generateNewData =
                      openIndex == searchResult.indexOf(item) ? false : true;
                  openIndex = searchResult.indexOf(item);
                }
                return ListTile(
                  title: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: getImage(item['country']),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Container(
                        width: 30.0,
                        child: Text(
                          item['country'],
                          style: TextStyle(
                            color: Colors.yellow[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder(
                          future: getName(item['country']),
                          builder: (contex, snapshot) {
                            if (item['name'] == null) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                item['name'] = snapshot.data;
                                return Text(
                                  snapshot.data,
                                  maxLines: 2,
                                );
                              } else
                                return Text('Getting name...');
                            }
                            return Text(
                              item['name'],
                            );
                          },
                        ),
                      ),
                      Text(
                        item['num'].toString(),
                        style: TextStyle(
                          color: Colors.deepOrange[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
              body: Container(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF001F46),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(20.0),
                        ),
                      ),
                      child: FutureBuilder(
                        future: resultData(item['country']),
                        builder: (context, snapshot) {
                          if (generateNewData) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                isOpening = Text('An error occured. @@');
                              }
                              isOpening = MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                child: snapshot.data,
                              );
                            } else {
                              isOpening = Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.0,
                                    ),
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              );
                            }
                          }
                          return isOpening;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                      child: Container(
                        height: 2.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF001F46),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ).toList());
  }

  Future<Widget> resultData(String code) async {
    List result;
    try {
      Response response;
      if (_cityTextControler.text == "") {
        response = await get(Uri.parse('${worldClock.path}/C/$code'));
      } else {
        response = await get(
            Uri.parse('${worldClock.path}/C/$code/_cityTextControler.text'));
      }
      result = jsonDecode(response.body);
    } catch (e) {
      result = ['error getting data! $code'];
    }
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: result.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: InkWell(
            child: Container(
              child: Text(
                result[index],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
            onTap: () {
              print('you tapped');
            },
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          color: Colors.white,
        );
      },
    );
  }

  Widget headerNote(String title) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.grey[500],
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        Spacer(),
      ],
    );
  }

  BoxShadow defaultShadow() {
    return BoxShadow(
      color: Colors.grey.withOpacity(1),
      spreadRadius: 0.1,
      blurRadius: 2,
      offset: Offset(0, 3),
    );
  }

  Widget searchBar() {
    return Container(
      alignment: AlignmentDirectional.bottomCenter,
      decoration: BoxDecoration(
        color: Color(0xFF001F46),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5.0),
                  topRight: Radius.circular(1.0),
                  bottomLeft: Radius.circular(5.0),
                  bottomRight: Radius.circular(1.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 1.0,
                ),
                child: TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                  ],
                  controller: _cityTextControler,
                  decoration: const InputDecoration(
                    hintText: 'City',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(1.0),
                  topRight: Radius.circular(5.0),
                  bottomLeft: Radius.circular(1.0),
                  bottomRight: Radius.circular(5.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 1.0,
                ),
                child: TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                  ],
                  controller: _coutryTextControler,
                  decoration: const InputDecoration(
                    hintText: 'ISO',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
