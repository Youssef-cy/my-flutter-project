import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  static List<Map<String, String>> orders = [];

  const OrdersPage({super.key}); // ستتصل لاحقًا بقاعدة البيانات

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Orders")),
      body:
          OrdersPage.orders.isEmpty
              ? Center(child: Text("No orders yet"))
              : ListView.builder(
                itemCount: OrdersPage.orders.length,
                itemBuilder: (context, index) {
                  final order = OrdersPage.orders[index];
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text("Order ID: ${order['orderId']}"),
                      subtitle: Text("Status: ${order['status']}"),
                    ),
                  );
                },
              ),
    );
  }
}
