import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_contactlist_application/models/MyContact.dart';
import 'package:flutter_contactlist_application/services/auth.dart';
import 'package:flutter_contactlist_application/screens/login.dart';
import 'package:flutter_contactlist_application/components/MyDialog.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:time_span/time_span.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  DateFormat dateTimeFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  List myList = List.generate(4, (index) => "Item: ${index + 1}");
  ScrollController _scrollController = ScrollController();
  bool loadingVisible = false;
  bool endIndicatorVisible = false;
  int totalLength = 0;
  int half = 0;
  int snapLength = 0;
  int counter = 0;
  List<bool> isSelected = [true, false];
  bool originalTimeVisible = true;
  bool timeAgoVisible = false;
  List<String> timeAgoList = [];

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          _scrollController.position.userScrollDirection ==
              ScrollDirection.reverse) {
        _getMoreData();
      }
    });
  }

  _sendContactData() {
    List<MyContact> _newContact = [];

    for (int i = 0; i < 5; i++) {
      MyContact _contactObject = new MyContact(
          name: _getRandomName(),
          phone: _getRandomPhone(),
          checkInDate: _getRandomDateTime());
      _newContact.add(_contactObject);
    }

    for (int i = 0; i < _newContact.length; i++) {
      print(_newContact[i].getName());
      print(_newContact[i].getPhone());
      print(_newContact[i].getCheckInDate());
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

  DateTime _getRandomDateTime() {
    String randomDateTime = _getRandomDate() + " " + _getRandomTime();
    DateFormat dateTimeFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    return dateTimeFormat.parse(randomDateTime);
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
    var url = 'https://rlcm.000webhostapp.com/getData.php';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var list = json.decode(response.body);
      _contact = await list
          .map<MyContact>((json) => MyContact.fromJson(json))
          .toList();

      if (counter == 0) {
        snapLength = _contact.length;
        half = (snapLength / 2).round();
        totalLength = snapLength < half ? snapLength : half;
        counter++;
      } else {
        snapLength = _contact.length;
      }

      for (int i = 0; i < snapLength; i++) {
        DateTime? dataDateTime = _contact[i].getCheckInDate();

        if (dataDateTime != null) {
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
          timeAgoList.add(message);
        }
      }

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(appBar: _appBar(), body: _body());
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
            isSelected[i] = i == index;
          }

          if (index == 0) {
            originalTimeVisible = true;
            timeAgoVisible = false;
          } else {
            originalTimeVisible = false;
            timeAgoVisible = true;
          }
        });
      },
      isSelected: isSelected,
    );
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
                      return Future.delayed(Duration(seconds: 1), () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Page Refreshed'),
                        ));
                      });
                    },
                    child: FutureBuilder(
                        initialData: [],
                        future: _getContactList(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.data.length > 0) {
                            return ListView.builder(
                                physics: const BouncingScrollPhysics(
                                    parent:
                                        const AlwaysScrollableScrollPhysics()),
                                controller: _scrollController,
                                itemCount: totalLength,
                                itemBuilder: (context, index) {
                                  return Card(
                                      child: ListTile(
                                          title: Text(
                                              snapshot.data[index].getName()),
                                          subtitle: Column(children: [
                                            Text(snapshot.data[index]
                                                .getPhone()),
                                            Visibility(
                                                visible: originalTimeVisible,
                                                child: Text(dateTimeFormat
                                                    .format(snapshot.data[index]
                                                        .getCheckInDate()))),
                                            Visibility(
                                                visible: timeAgoVisible,
                                                child: Text(timeAgoList[index]))
                                          ])));
                                });
                          } else {
                            print("I am here");
                            return Center(
                              child: Text("No Data found"),
                            );
                          }
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
  // _body() {
  //   return Stack(
  //     children: [
  //       Positioned.fill(
  //           bottom: 70,
  //           child: FutureBuilder(
  //               initialData: [],
  //               future: _getContactList(),
  //               builder: (BuildContext context, AsyncSnapshot snapshot) {
  //                 if (snapshot.hasData) {
  //                   return new RefreshIndicator(
  //                       onRefresh: () {
  //                         return Future.delayed(Duration(seconds: 1), () {
  //                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //                             content: const Text('Page Refreshed'),
  //                           ));
  //                         });
  //                       },
  //                       child: ListView.builder(
  //                           controller: _scrollController,
  //                           itemCount: snapshot.data.length,
  //                           itemBuilder: (context, index) {
  //                             return Card(
  //                                 semanticContainer: true,
  //                                 clipBehavior: Clip.antiAliasWithSaveLayer,
  //                                 elevation: 5,
  //                                 margin: EdgeInsets.all(10),
  //                                 child: Column(
  //                                   children: [
  //                                     _data('Name: ',
  //                                         snapshot.data[index].getName()),
  //                                     _data('Phone: ',
  //                                         snapshot.data[index].getPhone()),
  //                                     _data(
  //                                         'Check In: ',
  //                                         snapshot.data[index]
  //                                             .getCheckInDate()),
  //                                   ],
  //                                 )
  //                                 // child: ListTile(title: _data('Name: ', 'Name'))
  //                                 );
  //                           }));
  //                 } else {
  //                   return Container();
  //                 }
  //               })),
  //       Positioned.fill(
  //           bottom: 20,
  //           child: Align(
  //               alignment: Alignment.bottomCenter,
  //               child: Visibility(
  //                   visible: endIndicatorVisible,
  //                   child: Text('You have reached end of the list')))),
  //       Positioned.fill(
  //           bottom: 20,
  //           child: Align(
  //               alignment: Alignment.bottomCenter,
  //               child: Visibility(
  //                   visible: loadingVisible,
  //                   child: CircularProgressIndicator(
  //                       valueColor:
  //                           AlwaysStoppedAnimation<Color>(Colors.blue))))),
  //     ],
  //   );
  // }

  // _body() {
  //   return RefreshIndicator(
  //       onRefresh: () {
  //         return Future.delayed(Duration(seconds: 1), () {
  //           setState(() {
  //             _demoData.addAll(["Ionic", "Xamarin"]);
  //           });
  //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //             content: const Text('Page Refreshed'),
  //           ));
  //         });
  //       },
  //       child: ListView.builder(
  //           controller: _scrollController,
  //           itemCount: myList.length < 15 ? myList.length : 15,
  //           itemBuilder: (context, index) {
  //             return Card(child: ListTile(title: Text(myList[index])));
  //           }));
  // }
}

// _dataContainer() {
//   return Container(
//       width: double.infinity,
//       height: 100,
//       child: Card(
//         semanticContainer: true,
//         clipBehavior: Clip.antiAliasWithSaveLayer,
//         child: Column(
//           children: [
//             _data('Name: ', 'Name'),
//             _data('Phone: ', 'Phone'),
//             _data('Check in: ', 'Check in')
//           ],
//         ),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         elevation: 5,
//         margin: EdgeInsets.all(10),
//       ));
// }

_data(String title, String? data) {
  return Padding(
    padding: EdgeInsets.all(5),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [Text(title), SizedBox(width: 5), Text(data!)],
      ),
    ),
  );
}
