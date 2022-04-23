import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';

class SlideShow extends StatefulWidget {
  final String docName;
  final String docId;
  SlideShow({Key? key, required this.docName, required this.docId})
      : super(key: key);

  @override
  State<SlideShow> createState() => _SlideShowState();
}

class _SlideShowState extends State<SlideShow> {
  final ingredients = FirebaseFirestore.instance.collection('ingredient');
  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController(initialPage: 0);
    String docName = widget.docName;
    String docId = widget.docId;
    List<Map<String, String>> countList = [];

    return FutureBuilder(
        future: ingredients.doc(docId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data =
                snapshot.data!.data()! as Map<String, dynamic>;
            TextEditingController controller = TextEditingController();
            List<Widget> dataList =
                setDataListWidget(data[docName], controller);

            return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(
                      Icons.backspace,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: Text(docName),
                ),
                body: Column(
                  children: [
                    Flexible(
                      child: PageView(
                        pageSnapping: true,
                        controller: pageController,
                        children: dataList,
                      ),
                      flex: 1,
                    ),
                    TextButton(
                        child: Text(">", style: TextStyle(color: Colors.black)),
                        onPressed: () {
                          countList.add({
                            data[docName][pageController.page!.toInt() + 1]
                                ['name']: controller.text
                          });

                          print(pageController.page);
                          controller.clear();
                          pageController.animateToPage(1,
                              duration: Duration(seconds: 1),
                              curve: Curves.easeIn);
                          if (pageController.page == dataList.length - 1) {
                            print(countList);
                            String message = json
                                .encode(countList)
                                .replaceAll("{", '')
                                .replaceAll("}", '');
                            print(message);
                            _sendSMS(message, [data[docName][0]['count']]);
                          }
                        })
                  ],
                ));
          } else {
            return Text("Loading",
                style: TextStyle(
                  color: Colors.black,
                ));
          }
        });
  }

  List<Widget> setDataListWidget(
      List<dynamic> list, TextEditingController controller) {
    List<Widget> datalist = [];
    for (var i = 1; i < list.length; i++) {
      datalist.add(Container(
          width: double.infinity,
          height: 200,
          child: Column(
            children: [
              Text(list[i]['name'] + ' 총 있어야하는 개수' + list[i]['count']),
              SizedBox(
                width: 100,
                child: TextField(
                  decoration: InputDecoration(),
                  controller: controller,
                ),
              )
            ],
          )));
    }
    return datalist;
  }

  void _sendSMS(String message, List<String> recipients) async {
    var status = await Permission.sms.status;
    if (status.isGranted) {
      String _result = await sendSMS(message: message, recipients: recipients)
          .catchError((onError) => print(onError));
      print(_result);
    } else if (status.isDenied) {
      Permission.sms.request();
      print(status);
    }
  }
}
