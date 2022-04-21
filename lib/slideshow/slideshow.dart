import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
      body: FutureBuilder(
          future: ingredients.doc(docId).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> data =
                  snapshot.data!.data()! as Map<String, dynamic>;
              List<Widget> dataList = setDataListWidget(data[docName]);
              return Column(
                children: [
                  PageView(
                    pageSnapping: true,
                    controller: pageController,
                    children: dataList,
                  ),
                  TextButton(
                    child: Text(">"),
                    onPressed: () => pageController.animateToPage(1,
                        duration: Duration(seconds: 1), curve: Curves.easeIn),
                  )
                ],
              );
            } else {
              return Text("Loading");
            }
          }),
    );
  }

  List<Widget> setDataListWidget(List<dynamic> list) {
    List<Widget> datalist = [];
    for (var i = 0; i < list.length; i++) {
      datalist.add(Container(child: Text(list[i]['name'])));
    }
    return datalist;
  }
}
