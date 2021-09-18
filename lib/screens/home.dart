import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_contactlist_application/models/MyContact.dart';
import 'package:flutter_contactlist_application/services/auth.dart';
import 'package:flutter_contactlist_application/components/MyDialog.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share/share.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  DateFormat dateTimeFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  late Future<List<MyContact>> _mycontact;
  ScrollController _scrollController = ScrollController();
  bool loadingVisible = false;
  bool endIndicatorVisible = false;
  int totalLength = 0;
  int half = 0;
  int snapLength = 0;
  int counter = 0;
  List<bool> isSelected = [true, false];
  List<String> timeAgoList = [];
  List<Color> colorList = [
    Colors.pink,
    Colors.red,
    Colors.deepOrange,
    Colors.orange,
    Colors.green,
    Colors.cyan,
    Colors.blue,
    Colors.purple
  ];

  @override
  void initState() {
    super.initState();
    _mycontact = _getContactList();
    getViewState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          _scrollController.position.userScrollDirection ==
              ScrollDirection.reverse) {
        counter++;
        _getMoreData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _body());
  }

  saveViewState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setStringList(
        "isSelected",
        isSelected.map((e) => e ? 'true' : 'false').toList(),
      );
    });
  }

  getViewState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isSelected = (prefs
              .getStringList('isSelected')
              ?.map((e) => e == 'true' ? true : false)
              .toList() ??
          [true, false]);
    });
  }

  _sendContactData() async {
    List<MyContact> _newContact = [];

    for (int i = 0; i < 5; i++) {
      MyContact _contactObject = MyContact(
          name: _getRandomName(),
          phone: _getRandomPhone(),
          checkInDate: _getRandomDateTime());
      _newContact.add(_contactObject);
    }

    String data = jsonEncode(_newContact.map((e) => e.toJson()).toList());

    var url = 'https://rlcm.000webhostapp.com/insertContact.php';

    // Starting Web Call with data.
    var response = await http.post(Uri.parse(url), body: data);

    // Getting Server response into variable.
    var message = await json.decode(response.body);

    if (response.statusCode == 200) {
      print(message);
      setState(() {
        _mycontact = _getContactList();
      });
    } else {
      print(message);
    }
  }

  String _getRandomPhone() {
    var randomTest = new Random();
    var randomPhone = "01";

    for (var i = 0; i < 8; i++) {
      randomPhone = randomPhone + randomTest.nextInt(9).toString();
    }

    return randomPhone;
  }

  String _getRandomName() {
    var name = [
      "Emma",
      "Faris",
      "Ava",
      "Isabella",
      "Eagan",
      "Sophia",
      "Mia",
      "Cace",
      "Charlotte",
      "Amelia",
      "Evelyn",
      "Daegan",
      "Conan",
      "Abigail",
      "Aaren",
      "Olivia",
      "Badden",
      "Beau",
      "Iggy",
      "Edwin"
    ];

    var randomTest = new Random();
    int size = name.length;
    int index = randomTest.nextInt(size);
    return name[index];
  }

  String _getRandomDateTime() {
    String randomDateTime = _getRandomDate() + " " + _getRandomTime();
    return randomDateTime;
  }

  String _getRandomDate() {
    var randomTest = new Random();
    DateTime startDate = DateTime.parse("2020-01-01");
    Duration diff = DateTime.now().difference(startDate);
    int range = diff.inDays.toInt();

    var result = randomTest.nextInt(range);
    DateTime randomD = startDate.add(Duration(days: result));
    DateFormat dateTimeFormat = DateFormat("yyyy-MM-dd");

    return dateTimeFormat.format(randomD);
  }

  String _getRandomTime() {
    var randomTest = new Random();
    int minHour = 0;
    int maxHour = 23;
    int minMinuteAndSecond = 0;
    int maxMinuteAndSecond = 59;

    int rHour = minHour + randomTest.nextInt(maxHour - minHour);
    int rMinute = minMinuteAndSecond +
        randomTest.nextInt(maxMinuteAndSecond - minMinuteAndSecond);
    int rSecond = minMinuteAndSecond +
        randomTest.nextInt(maxMinuteAndSecond - minMinuteAndSecond);

    String randomHours = "";
    String randomMinutes = "";
    String randomSeconds = "";
    if (rHour < 10) {
      randomHours = "0" + rHour.toString();
    } else {
      randomHours = rHour.toString();
    }

    if (rMinute < 10) {
      randomMinutes = "0" + rMinute.toString();
    } else {
      randomMinutes = rMinute.toString();
    }

    if (rSecond < 10) {
      randomSeconds = "0" + rSecond.toString();
    } else {
      randomSeconds = rSecond.toString();
    }

    String randomTime =
        randomHours + ":" + randomMinutes.toString() + ":" + randomSeconds;

    return randomTime;
  }

  Future<List<MyContact>> _getContactList() async {
    List<MyContact> _contact = [];
    List<String> _timeAgo = [];
    var url = 'https://rlcm.000webhostapp.com/getData.php';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var list = json.decode(response.body);
      _contact = await list
          .map<MyContact>((json) => MyContact.fromJson(json))
          .toList();
      snapLength = _contact.length;
      half = (_contact.length / 2).round();
      totalLength = _contact.length < half ? _contact.length : half;

      for (int i = 0; i < snapLength; i++) {
        String dataDateTimeString;

        dataDateTimeString = _contact[i].getCheckInDate()!;

        DateTime dataDateTime = dateTimeFormat.parse(dataDateTimeString);

        Duration diff = DateTime.now().difference(dataDateTime);
        String message = '';
        if (diff.inDays >= 1) {
          message = '${diff.inDays} day(s) ago';
        } else if (diff.inHours >= 1) {
          message = '${diff.inHours} hour(s) ago';
        } else if (diff.inMinutes >= 1) {
          message = '${diff.inMinutes} minute(s) ago';
        } else if (diff.inSeconds >= 1) {
          message = '${diff.inSeconds} second(s) ago';
        } else {
          message = 'just now';
        }
        _timeAgo.add(message);
      }

      setState(() {
        timeAgoList = _timeAgo;
      });

      return _contact;
    }

    return _contact;
  }

  _getMoreData() {
    setState(() {
      loadingVisible = true;
    });
    print("getMoreData");

    Future.delayed(Duration(seconds: 2), () {
      if (totalLength != snapLength) {
        totalLength = snapLength;
        setState(() {
          loadingVisible = false;
        });
      } else {
        setState(() {
          loadingVisible = false;
          endIndicatorVisible = true;

          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              endIndicatorVisible = false;
            });
          });
        });
      }
    });
  }

  final AuthService _auth = new AuthService();
  MyDialog dialog = new MyDialog();

  void signOut() {
    dialog.waiting(context, 'Logging Out...');
    Timer(Duration(seconds: 3), () async {
      Navigator.pop(dialog.getDialogContext());
      await _auth.signOut();
    });
  }

  _appBar() {
    return AppBar(
      title: Text('Contact List'),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Log Out',
          onPressed: () {
            signOut();
          },
        ),
      ],
    );
  }

  _toggleButtons() {
    return ToggleButtons(
      children: <Widget>[
        // first toggle button
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Original Time',
          ),
        ),
        // second toggle button
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Time ago',
          ),
        )
      ],
      // logic for button selection below
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < isSelected.length; i++) {
            if (i == index) {
              isSelected[i] = true;
            } else {
              isSelected[i] = false;
            }
          }
          saveViewState();
        });
      },
      isSelected: isSelected,
    );
  }

  int getRandomColor() {
    var randomTest = new Random();
    int colorLength = colorList.length;
    int randomIndex = 0 + randomTest.nextInt(colorLength - 0);

    return randomIndex;
  }

  _userLogo() {
    return Icon(Icons.account_circle_sharp,
        size: 60, color: colorList[getRandomColor()]);
  }

  _dataField(String string) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Align(alignment: Alignment.centerLeft, child: Text(string)),
    );
  }

  _listTileAction(String name, String phone, String dateTime, String timeAgo) {
    return IconButton(
      icon: const Icon(Icons.share),
      tooltip: 'Share Information',
      onPressed: () {
        _onShareData(name, phone, dateTime, timeAgo);
      },
    );
  }

  _onShareData(
      String name, String phone, String dateTime, String timeago) async {
    Share.share(name + "\n" + phone + "\n" + dateTime + "\n" + timeago);
  }

  _body() {
    return Stack(
      children: [
        Positioned.fill(
            child: Container(
                margin: EdgeInsets.all(5),
                height: 50,
                child: Align(
                    alignment: Alignment.topRight, child: _toggleButtons()))),
        Positioned.fill(
            top: 60,
            bottom: 60,
            child: Align(
                alignment: Alignment.center,
                child: RefreshIndicator(
                    onRefresh: () {
                      _sendContactData();
                      MyDialog dialog = new MyDialog();
                      dialog.waiting(context, 'Generate 5 random Data');
                      return Future.delayed(Duration(seconds: 2), () {
                        Navigator.pop(dialog.getDialogContext());
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Added 5 Random Record'),
                        ));
                      });
                    },
                    child: FutureBuilder(
                        initialData: [],
                        future: _mycontact,
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasError) print(snapshot.error);
                          return snapshot.hasData
                              ? ListView.builder(
                                  physics: const BouncingScrollPhysics(
                                      parent:
                                          const AlwaysScrollableScrollPhysics()),
                                  controller: _scrollController,
                                  itemCount: totalLength,
                                  itemBuilder: (context, index) {
                                    return Card(
                                        child: ListTile(
                                            leading: _userLogo(),
                                            trailing: _listTileAction(
                                                snapshot.data[index].getName(),
                                                snapshot.data[index].getPhone(),
                                                snapshot.data[index]
                                                    .getCheckInDate(),
                                                timeAgoList[index]),
                                            title: Text(
                                                snapshot.data[index].getName(),
                                                style: TextStyle(fontSize: 20)),
                                            subtitle: Column(children: [
                                              _dataField(snapshot.data[index]
                                                  .getPhone()),
                                              Visibility(
                                                  visible: isSelected[0],
                                                  child: _dataField(snapshot
                                                      .data[index]
                                                      .getCheckInDate())),
                                              Visibility(
                                                  visible: isSelected[1],
                                                  child: _dataField(
                                                      timeAgoList[index]))
                                            ])));
                                  })
                              : Center(child: CircularProgressIndicator());
                        })))),
        Positioned.fill(
            bottom: 20,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Visibility(
                    visible: endIndicatorVisible,
                    child: Text('You have reached end of the list')))),
        Positioned.fill(
            bottom: 20,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Visibility(
                    visible: loadingVisible,
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.blue)))))
      ],
    );
  }
}
