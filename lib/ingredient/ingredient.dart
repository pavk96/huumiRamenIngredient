import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:practice/presentation/Trash.dart';

class IngredientList extends StatefulWidget {
  IngredientList({Key? key}) : super(key: key);

  @override
  State<IngredientList> createState() => _IngredientListState();
}

class _IngredientListState extends State<IngredientList> {
  final items = List<String>.generate(7, (index) => "I'm ${index + 1}");
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        String item = items[index];
        return Slidable(
            key: Key(item),
            endActionPane: ActionPane(
              children: [
                SlidableAction(
                  onPressed: (context) {},
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  icon: Trash.trash_alt,
                  label: "Modify",
                ),
                SlidableAction(
                  onPressed: (context) {
                    items.removeAt(index);
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: "Delete",
                ),
              ],
              motion: ScrollMotion(),
              dismissible: DismissiblePane(
                onDismissed: () => {},
              ),
            ),
            child: ListTile(title: Text("$item")));
      },
      itemCount: items.length,
    );
  }
}
