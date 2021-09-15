import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contactlist_application/services/auth.dart';
import 'package:flutter_contactlist_application/screens/login.dart';
import 'package:flutter_contactlist_application/components/MyDialog.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List myList = List.generate(50, (index) => "Item: ${index + 1}");
  ScrollController _scrollController = ScrollController();
  bool loadingVisible = false;
  bool endIndicatorVisible = false;
  int totalLength = 0;
  int counter = 0;
  int half = 0;
  @override
  void initState() {
    super.initState();
    half = (myList.length / 2).round();
    totalLength = myList.length < half ? myList.length : half;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      } else {
        _removeEndIndicator();
      }
    });
  }

  _removeEndIndicator() {
    setState(() {
      endIndicatorVisible = false;
    });
  }

  _getMoreData() {
    setState(() {
      loadingVisible = true;
    });
    print("getMoreData");

    Future.delayed(Duration(seconds: 2), () {
      if (totalLength != myList.length) {
        totalLength = myList.length;
        setState(() {
          loadingVisible = false;
        });
      } else {
        setState(() {
          loadingVisible = false;
          endIndicatorVisible = true;
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
      centerTitle: true,
      actions: [
        PopupMenuButton<int>(
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
                  PopupMenuItem<int>(
                      value: 0,
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: Colors.red),
                          const SizedBox(width: 8),
                          Text('Sign Out')
                        ],
                      ))
                ])
      ],
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        signOut();
        break;
    }
  }

  _body() {
    return Stack(
      children: [
        Positioned.fill(
            bottom: 70,
            child: RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(Duration(seconds: 1), () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('Page Refreshed'),
                    ));
                  });
                },
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: totalLength,
                    itemBuilder: (context, index) {
                      return Card(child: ListTile(title: Text(myList[index])));
                    }))),
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
                            AlwaysStoppedAnimation<Color>(Colors.blue))))),
      ],
    );
  }

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

_data(String title, String data) {
  return Padding(
    padding: EdgeInsets.all(5),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [Text(title), SizedBox(width: 5), Text(data)],
      ),
    ),
  );
}
