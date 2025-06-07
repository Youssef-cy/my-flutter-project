import 'package:flutter/material.dart';

class InventoryItem {
  String name;
  int quantity;
  double price;

  InventoryItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}

class InventoryPage extends StatefulWidget {
  static List<InventoryItem> items = [];

  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final nameController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();

  void _addOrEditItem({InventoryItem? item, int? index}) {
    if (item != null) {
      nameController.text = item.name;
      quantityController.text = item.quantity.toString();
      priceController.text = item.price.toString();
    } else {
      nameController.clear();
      quantityController.clear();
      priceController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (_) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: "Name"),
                  ),
                  TextField(
                    controller: quantityController,
                    decoration: InputDecoration(labelText: "Quantity"),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: priceController,
                    decoration: InputDecoration(labelText: "Price"),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text(item == null ? "Add Item" : "Save Changes"),
                    onPressed: () {
                      final newItem = InventoryItem(
                        name: nameController.text,
                        quantity: int.tryParse(quantityController.text) ?? 0,
                        price: double.tryParse(priceController.text) ?? 0.0,
                      );

                      setState(() {
                        if (item == null) {
                          InventoryPage.items.add(newItem);
                        } else if (index != null) {
                          InventoryPage.items[index] = newItem;
                        }
                      });

                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _showItemOptions(int index) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Select Action"),
            content: Text("Do you want to edit or delete this item?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _addOrEditItem(
                    item: InventoryPage.items[index],
                    index: index,
                  );
                },
                child: Text("Edit"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    InventoryPage.items.removeAt(index);
                  });
                  Navigator.pop(context);
                },
                child: Text("Delete", style: TextStyle(color: Colors.red)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inventory"),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: () => _addOrEditItem()),
        ],
      ),
      body:
          InventoryPage.items.isEmpty
              ? Center(child: Text("No inventory items yet"))
              : ListView.builder(
                itemCount: InventoryPage.items.length,
                itemBuilder: (context, index) {
                  final item = InventoryPage.items[index];
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text(
                        "Quantity: ${item.quantity}, Price: ${item.price}",
                      ),
                      onTap: () => _showItemOptions(index),
                    ),
                  );
                },
              ),
    );
  }
}
