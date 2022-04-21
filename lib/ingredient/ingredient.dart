import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:practice/ingredient_detail/ingredient_detail.dart';

class IngredientList extends StatefulWidget {
  IngredientList({Key? key}) : super(key: key);

  @override
  State<IngredientList> createState() => _IngredientListState();
}

class _IngredientListState extends State<IngredientList> {
  final ingredients = FirebaseFirestore.instance.collection('ingredient');

  TextEditingController newCategoryNameController = TextEditingController();
  void updateDoc(String docId, String docName, String newTitle) async {
    await FirebaseFirestore.instance
        .collection('ingredient')
        .doc(docId)
        .get()
        .then((value) {
      Map<String, dynamic> data = value.data()!;
      List datalist = data[docName];
      setState(() {
        FirebaseFirestore.instance
            .collection('ingredient')
            .doc(docId)
            .set({newTitle: datalist});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ingredients.get(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                String docId =
                    snapshot.data.docs[index].reference.id.toString();
                String docName = snapshot.data.docs[index]
                    .data()
                    .keys
                    .toString()
                    .replaceAll('(', '')
                    .replaceAll(")", '');
                return Slidable(
                    key: Key(docId),
                    endActionPane: ActionPane(
                      children: [
                        SlidableAction(
                          onPressed: (context) => showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("선택한 카테고리 이름을 변경하세요"),
                                  content: Container(
                                      height: 200,
                                      child: Column(
                                        children: [
                                          TextField(
                                            autofocus: true,
                                            decoration: InputDecoration(
                                                labelText: "Name",
                                                hintText: docName),
                                            controller:
                                                newCategoryNameController,
                                          ),
                                        ],
                                      )),
                                  actions: [
                                    TextButton(
                                      child: Text("Cancel"),
                                      onPressed: () {
                                        newCategoryNameController.clear();
                                        Navigator.pop(context);
                                      },
                                    ),
                                    TextButton(
                                      child: Text("Update"),
                                      onPressed: () {
                                        if (newCategoryNameController
                                            .text.isNotEmpty) {
                                          setState(() {
                                            updateDoc(docId, docName,
                                                newCategoryNameController.text);
                                          });
                                        }
                                        newCategoryNameController.clear();
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
                              FirebaseFirestore.instance
                                  .collection("ingredient")
                                  .doc(docName)
                                  .delete();
                            });
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: "Delete",
                        ),
                      ],
                      motion: ScrollMotion(),
                      dismissible: DismissiblePane(
                        onDismissed: () {
                          FirebaseFirestore.instance
                              .collection("ingredient")
                              .doc(docId)
                              .delete();
                        },
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: TextButton(
                        child: Text("$docName"),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => IngredientDetail(
                                      doc_name: docName, doc_id: docId)));
                        },
                      ),
                    ));
              },
              itemCount: snapshot.data.docs.length,
            );
          } else {
            return Text("Loading");
          }
        });
  }
}
