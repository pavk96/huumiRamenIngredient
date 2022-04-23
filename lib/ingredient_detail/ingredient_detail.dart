import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../slideshow/slideshow.dart';

class IngredientDetail extends StatefulWidget {
  final String doc_name;
  final String doc_id;

  const IngredientDetail(
      {Key? key, required this.doc_name, required this.doc_id})
      : super(key: key);

  @override
  State<IngredientDetail> createState() => _IngredientDetailState();
}

class _IngredientDetailState extends State<IngredientDetail> {
  TextEditingController newIngredientNameController = TextEditingController();
  TextEditingController newIngredientCountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final CollectionReference<Map<String, dynamic>> ingredients =
        FirebaseFirestore.instance.collection('ingredient');
    final String docName = widget.doc_name;
    final String docId = widget.doc_id;
    void addField(String name, String count) async {
      await FirebaseFirestore.instance
          .collection('ingredient')
          .doc(docId)
          .get()
          .then((value) {
        Map<String, dynamic> data = value.data()!;
        List datalist = data[docName];
        datalist.add({"name": name, "count": count});
        setState(() {
          FirebaseFirestore.instance
              .collection('ingredient')
              .doc(docId)
              .set({docName: datalist});
        });
      });
    }

    void updateField(int index, String name, String count) async {
      await FirebaseFirestore.instance
          .collection('ingredient')
          .doc(docId)
          .get()
          .then((value) {
        Map<String, dynamic> data = value.data()!;
        List datalist = data[docName];
        datalist[index] = ({"name": name, "count": count});
        setState(() {
          FirebaseFirestore.instance
              .collection('ingredient')
              .doc(docId)
              .set({docName: datalist});
        });
      });
    }

    void removeField(int index) async {
      await FirebaseFirestore.instance
          .collection('ingredient')
          .doc(docId)
          .get()
          .then((value) {
        Map<String, dynamic> data = value.data()!;
        List datalist = data[docName];
        datalist.removeAt(index);
        setState(() {
          FirebaseFirestore.instance
              .collection('ingredient')
              .doc(docId)
              .set({docName: datalist});
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.backspace),
          color: Colors.black,
          onPressed: () => {Navigator.pop(context)},
        ),
        title: Text(
          docName,
          style: TextStyle(color: Colors.blue),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SlideShow(docName: docName, docId: docId)));
              },
              icon: Icon(
                Icons.start_outlined,
                color: Colors.black,
              ))
        ],
      ),
      body: FutureBuilder(
          future: ingredients.doc(docId).get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> data =
                  snapshot.data!.data()! as Map<String, dynamic>;
              return ListView.builder(
                  itemCount: data[docName] != null ? data[docName].length : 0,
                  itemBuilder: (context, index) {
                    return Slidable(
                      key: UniqueKey(),
                      endActionPane: ActionPane(
                        children: [
                          SlidableAction(
                            onPressed: (context) => showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("선택한 데이터를 변경하세요"),
                                    content: Container(
                                        height: 200,
                                        child: Column(
                                          children: [
                                            TextField(
                                              autofocus: true,
                                              decoration: InputDecoration(
                                                  labelText: "Name",
                                                  hintText: data[docName][index]
                                                      ['name']),
                                              controller:
                                                  newIngredientNameController,
                                            ),
                                            TextField(
                                              autofocus: true,
                                              decoration: InputDecoration(
                                                  labelText: "MaxCount",
                                                  hintText: data[docName][index]
                                                      ['count']),
                                              controller:
                                                  newIngredientCountController,
                                            ),
                                          ],
                                        )),
                                    actions: [
                                      TextButton(
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          newIngredientNameController.clear();
                                          Navigator.pop(context);
                                        },
                                      ),
                                      TextButton(
                                        child: Text("Update"),
                                        onPressed: () {
                                          if (newIngredientNameController
                                                  .text.isNotEmpty &&
                                              newIngredientCountController
                                                  .text.isNotEmpty) {
                                            updateField(
                                                index,
                                                newIngredientNameController
                                                    .text,
                                                newIngredientCountController
                                                    .text);
                                          }
                                          newIngredientNameController.clear();
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  );
                                }),
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            icon: Icons.border_color,
                            label: "Modify",
                          ),
                          SlidableAction(
                            onPressed: (context) {
                              setState(() {
                                removeField(index);
                              });
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: "Delete",
                          ),
                        ],
                        motion: ScrollMotion(),
                        dismissible: DismissiblePane(onDismissed: () {
                          setState(() {
                            removeField(index);
                          });
                        }),
                      ),
                      child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(data[docName][index]['name']),
                              Text(data[docName][index]['count'].toString()),
                              Icon(Icons.start)
                            ],
                          )),
                    );
                  });
            } else {
              return Text("loading");
            }
          }),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("새로운 데이터를 입력하세요"),
                    content: Container(
                        height: 200,
                        child: Column(
                          children: [
                            TextField(
                              autofocus: true,
                              decoration: InputDecoration(labelText: "Name"),
                              controller: newIngredientNameController,
                            ),
                            TextField(
                              autofocus: true,
                              decoration:
                                  InputDecoration(labelText: "MaxCount"),
                              controller: newIngredientCountController,
                            ),
                          ],
                        )),
                    actions: [
                      TextButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          newIngredientNameController.clear();
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text("Create"),
                        onPressed: () {
                          if (newIngredientNameController.text.isNotEmpty &&
                              newIngredientCountController.text.isNotEmpty) {
                            addField(newIngredientNameController.text,
                                newIngredientCountController.text);
                          }
                          newIngredientNameController.clear();
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                });
          }),
    );
  }
}
