import 'package:flutter/material.dart';
import 'package:practice/themeStyle.dart';

import 'ingredient/ingredient.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false, theme: themeStyle, home: Practice()));
}

class Practice extends StatelessWidget {
  const Practice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("어플이름?"),
        actions: [
          IconButton(
            icon: Icon(Icons.search_outlined),
            onPressed: () => {},
            color: Colors.black,
          )
        ],
      ),
      body: IngredientList(),
      floatingActionButton:
          FloatingActionButton(onPressed: () => {}, child: Icon(Icons.add)),
    );
  }
}
