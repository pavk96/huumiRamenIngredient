import 'package:flutter/material.dart';
import 'package:practice/ingredient_detail/ingredient_detail.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:practice/themeStyle.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'ingredient/ingredient.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false, theme: themeStyle, home: Practice()));
}

class Practice extends StatefulWidget {
  const Practice({Key? key}) : super(key: key);

  @override
  State<Practice> createState() => _PracticeState();
}

class _PracticeState extends State<Practice> {
  TextEditingController newCategoryNameController = TextEditingController();

  Future<FirebaseApp> _initialization =
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text("風味ラーメン材料(후우미라멘 재료)"),
            ),
            body: IngredientList(),
            floatingActionButton: FloatingActionButton(
                onPressed: () => showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("새로운 카테고리를 입력하세요"),
                        content: Container(
                            height: 200,
                            child: Column(
                              children: [
                                TextField(
                                  autofocus: true,
                                  decoration:
                                      InputDecoration(labelText: "Name"),
                                  controller: newCategoryNameController,
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
                            child: Text("Create"),
                            onPressed: () {
                              if (newCategoryNameController.text.isNotEmpty) {
                                setState(() {
                                  createDoc(newCategoryNameController.text);
                                });
                              }
                              newCategoryNameController.clear();
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    }),
                child: Icon(Icons.add)),
          );
        });
  }

  void createDoc(String title) {
    FirebaseFirestore.instance
        .collection('ingredient')
        .doc()
        .set({"$title": []});
  }
}
