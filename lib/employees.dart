import 'package:flutter/material.dart';

class EmployeesPage extends StatefulWidget {
  static List<Map<String, String>> employees = [];

  const EmployeesPage({super.key});

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final shiftController = TextEditingController();
  final jobController = TextEditingController();
  final salaryController = TextEditingController();

  void _addOrEditEmployee({Map<String, String>? employee, int? index}) {
    if (employee != null) {
      nameController.text = employee['name'] ?? '';
      addressController.text = employee['address'] ?? '';
      shiftController.text = employee['shift'] ?? '';
      jobController.text = employee['job'] ?? '';
      salaryController.text = employee['salary'] ?? '';
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
                    controller: addressController,
                    decoration: InputDecoration(labelText: "Address"),
                  ),
                  TextField(
                    controller: shiftController,
                    decoration: InputDecoration(labelText: "Shift"),
                  ),
                  TextField(
                    controller: jobController,
                    decoration: InputDecoration(labelText: "Position"),
                  ),
                  TextField(
                    controller: salaryController,
                    decoration: InputDecoration(labelText: "Salary"),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text(index == null ? "Add" : "Update"),
                    onPressed: () {
                      final newEmployee = {
                        'name': nameController.text,
                        'address': addressController.text,
                        'shift': shiftController.text,
                        'job': jobController.text,
                        'salary': salaryController.text,
                      };

                      setState(() {
                        if (index == null) {
                          EmployeesPage.employees.add(newEmployee);
                        } else {
                          EmployeesPage.employees[index] = newEmployee;
                        }
                      });

                      nameController.clear();
                      addressController.clear();
                      shiftController.clear();
                      jobController.clear();
                      salaryController.clear();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _showOptionsDialog(int index) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Choose an action"),
            content: Text("Do you want to edit or delete this employee?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _addOrEditEmployee(
                    employee: EmployeesPage.employees[index],
                    index: index,
                  );
                },
                child: Text("Edit"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    EmployeesPage.employees.removeAt(index);
                  });
                  Navigator.pop(context);
                },
                child: Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Employees"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _addOrEditEmployee(),
          ),
        ],
      ),
      body:
          EmployeesPage.employees.isEmpty
              ? Center(child: Text("No employees yet"))
              : ListView.builder(
                itemCount: EmployeesPage.employees.length,
                itemBuilder: (context, index) {
                  final emp = EmployeesPage.employees[index];
                  return GestureDetector(
                    onTap: () => _showOptionsDialog(index),
                    child: Card(
                      margin: EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Name: ${emp['name']}"),
                            Text("Address: ${emp['address']}"),
                            Text("Shift: ${emp['shift']}"),
                            Text("Position: ${emp['job']}"),
                            Text("Salary: ${emp['salary']}"),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
