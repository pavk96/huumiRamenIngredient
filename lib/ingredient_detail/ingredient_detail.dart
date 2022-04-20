import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class IngredientDetail extends StatefulWidget {
  final String doc_name;

  const IngredientDetail({Key? key, required this.doc_name}) : super(key: key);

  @override
  State<IngredientDetail> createState() => _IngredientDetailState();
}

class _IngredientDetailState extends State<IngredientDetail> {
  final titleController = TextEditingController();

  final nameController = TextEditingController();

  final countController = TextEditingController();

  TextEditingController newIngredientNameController = TextEditingController();
  TextEditingController newIngredientCountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final CollectionReference<Map<String, dynamic>> ingredients =
        FirebaseFirestore.instance.collection('ingredient');
    final String docName = widget.doc_name;
    void addField(String name, String count) async {
      await FirebaseFirestore.instance
          .collection('ingredient')
          .doc(docName)
          .get()
          .then((value) {
        Map<String, dynamic> data = value.data()!;
        List datalist = data[docName];
        datalist.add({"name": name, "count": count});
        setState(() {
          FirebaseFirestore.instance
              .collection('ingredient')
              .doc(docName)
              .set({docName: datalist});
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.cancel),
          color: Colors.black,
          onPressed: () => {Navigator.pop(context)},
        ),
        title: TextField(
          controller: titleController,
          decoration: InputDecoration(hintText: docName),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check_circle),
            color: Colors.black,
            onPressed: () => {},
          ),
          Padding(padding: EdgeInsets.only(right: 20))
        ],
      ),
      body: FutureBuilder(
          future: ingredients.doc(docName).get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> data =
                  snapshot.data!.data()! as Map<String, dynamic>;
              return ListView.builder(
                  itemCount: data[docName].length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Row(
                          children: [
                            Text(data[docName][index]['name']),
                            Text(data[docName][index]['count'].toString()),
                            Icon(Icons.abc)
                          ],
                        ));
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
                    title: Text("새로운 카테고리를 입력하세요"),
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
