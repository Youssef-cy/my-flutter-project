import 'package:flutter/material.dart';

class TableItem {
  int number;

  TableItem({required this.number});
}

class TablesPage extends StatefulWidget {
  static List<TableItem> tables = [];

  @override
  _TablesPageState createState() => _TablesPageState();
}

class _TablesPageState extends State<TablesPage> {
  TextEditingController numberController = TextEditingController();

  void addTable() {
    numberController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return tableFormDialog(
          title: "Add Table",
          onSave: () {
            final number = int.tryParse(numberController.text) ?? 0;
            if (number > 0) {
              setState(() {
                TablesPage.tables.add(TableItem(number: number));
              });
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }

  void editTable(int index) {
    final table = TablesPage.tables[index];
    numberController.text = table.number.toString();

    showDialog(
      context: context,
      builder: (context) {
        return tableFormDialog(
          title: "Edit Table",
          onSave: () {
            final newNumber = int.tryParse(numberController.text) ?? 0;
            if (newNumber > 0) {
              setState(() {
                table.number = newNumber;
              });
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }

  AlertDialog tableFormDialog({
    required String title,
    required VoidCallback onSave,
  }) {
    return AlertDialog(
      title: Text(title),
      content: TextField(
        controller: numberController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: "Table Number"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton(onPressed: onSave, child: Text("Save")),
      ],
    );
  }

  void showOptionsDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("Choose an action"),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                editTable(index);
              },
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.blue),
                  SizedBox(width: 8),
                  Text("Edit"),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                setState(() {
                  TablesPage.tables.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text("Delete"),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tables")),
      floatingActionButton: FloatingActionButton(
        onPressed: addTable,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: TablesPage.tables.length,
        itemBuilder: (context, index) {
          final table = TablesPage.tables[index];
          return ListTile(
            leading: Icon(Icons.table_bar),
            title: Text("Table #${table.number}"),
            onTap: () => showOptionsDialog(index),
          );
        },
      ),
    );
  }
}
