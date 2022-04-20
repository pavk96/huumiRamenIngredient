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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ingredients.get(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                String docName =
                    snapshot.data.docs[index].reference.id.toString();
                return Slidable(
                    key: Key(docName),
                    endActionPane: ActionPane(
                      children: [
                        SlidableAction(
                          onPressed: (context) {},
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          icon: Icons.border_color,
                          label: "Modify",
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            print(docName);
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
                              .doc(docName)
                              .delete();
                        },
                      ),
                    ),
                    child: TextButton(
                      child: Text("$docName"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => IngredientDetail(
                                      doc_name: docName,
                                    )));
                      },
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
