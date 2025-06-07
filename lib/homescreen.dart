import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'employees.dart';
import 'inventory.dart';
import 'orders.dart';
import 'tables.dart'; 
import 'loginscreen.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _selectedIndex = 0;

  int employeeCount = 0;
  int inventoryCount = 0;
  int ordersCount = 0;
  int tablesCount = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check authentication status when dependencies change
    if (supabase.auth.currentSession == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Loginscreen()),
        );
      });
    }
  }
  void initState() {
    super.initState();
    refreshCounts();
      supabase.auth.onAuthStateChange.listen((data) async {
      final session = await data.session;
      if (session != null) {
        setState(() {
          // just refresh the counts when the session is valid  
          refreshCounts();
        });
      } else {
        setState(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Loginscreen()),
          );
        });
      }
    });
  }

  void refreshCounts() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        employeeCount = EmployeesPage.employees.length;
        inventoryCount = InventoryPage.items.length;
        ordersCount = OrdersPage.orders.length;
        tablesCount = TablesPage.tables.length;
      });
    });
  }

  void showInventoryListDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Inventory Items"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: InventoryPage.items.length,
              itemBuilder: (context, index) {
                final item = InventoryPage.items[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text("Qty: ${item.quantity}, Price: ${item.price}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.pop(context);
                          showEditDialog(index, item);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            InventoryPage.items.removeAt(index);
                            refreshCounts();
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void showEditDialog(int index, item) {
    TextEditingController nameController = TextEditingController(
      text: item.name,
    );
    TextEditingController quantityController = TextEditingController(
      text: item.quantity.toString(),
    );
    TextEditingController priceController = TextEditingController(
      text: item.price.toString(),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Item"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(labelText: "Quantity"),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: "Price"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text("Save"),
              onPressed: () {
                setState(() {
                  item.name = nameController.text;
                  item.quantity =
                      int.tryParse(quantityController.text) ?? item.quantity;
                  item.price =
                      double.tryParse(priceController.text) ?? item.price;
                  refreshCounts();
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget overviewCard({
    required IconData icon,
    required String title,
    required int count,
    required VoidCallback onTap,
    VoidCallback? onLongPress,
  }) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: 160,
        height: 140,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.teal),
            SizedBox(height: 10),
            Text(title, style: TextStyle(color: Colors.black87, fontSize: 16)),
            SizedBox(height: 6),
            Text("Total: $count", style: TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget overviewPage() {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            overviewCard(
              icon: Icons.people,
              title: "Employees",
              count: employeeCount,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmployeesPage()),
                );
              },
            ),
            overviewCard(
              icon: Icons.inventory,
              title: "Inventory",
              count: inventoryCount,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InventoryPage()),
                );
              },
              onLongPress: showInventoryListDialog,
            ),
            overviewCard(
              icon: Icons.shopping_cart,
              title: "Orders",
              count: ordersCount,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrdersPage()),
                );
              },
            ),
            overviewCard(
              icon: Icons.table_bar,
              title: "Tables",
              count: tablesCount,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TablesPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      overviewPage(),
      EmployeesPage(),
      InventoryPage(),
      OrdersPage(),
      TablesPage(), 
    ];

    return Builder(
      builder: (context) {
        return Scaffold(
          appBar: _selectedIndex == 0
                ? AppBar(
                  automaticallyImplyLeading: false,
              title: Text("overview"),
                actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(Icons.logout), // Changed icon
                    onPressed: () async{
                      await supabase.auth.signOut();
                      Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Loginscreen()),
                      );
                    },
                  ),
                ),
                ],
            )
              : null,
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
                refreshCounts();
              });
            },
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: "Overview"),
              NavigationDestination(icon: Icon(Icons.person), label: "Employees"),
              NavigationDestination(
                icon: Icon(Icons.inventory),
                label: "Inventory",
              ),
              NavigationDestination(
                icon: Icon(Icons.shopping_cart),
                label: "Orders",
              ),
              NavigationDestination(icon: Icon(Icons.table_bar), label: "Tables"),
            ],
          ),
          body: IndexedStack(index: _selectedIndex, children: pages),
        );
      }
    );
  }
}
