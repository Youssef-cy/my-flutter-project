import 'package:flutter/material.dart';
import 'package:flutter_application_1/homescreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Loginscreen extends StatelessWidget {
  const Loginscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final marketController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: 400,
          width: 320,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.grey[100],
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome Back!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: marketController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Enter your market name',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                    padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                onPressed:
                    () async {
                    final url = Uri.parse('http://localhost:5000/signup');
                    final response = await http.post(
                      url,
                      headers: {'Content-Type': 'application/json'},
                      body: json.encode({
                      'name': nameController.text,
                      'market_name': marketController.text,
                      'password': passwordController.text,
                      }),
                    );
                    final data = json.decode(response.body);


                    if (response.statusCode == 201) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Homescreen()),
                      );
                    } else {
                        showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Signup Failed'),
                          content: Text('${data['error']}\nStatus: ${response.statusCode}'),
                          actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                          ],
                        ),
                        );
                    }
                    },
                icon: const Icon(Icons.create),
                label: const Text("Sign Up"),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                onPressed: () async{
                  final response = await http.post(
                    Uri.parse('http://localhost:5000/login'),
                    headers: {'Content-Type': 'application/json'},
                    body: json.encode({
                      'name': nameController.text,
                      'market_name': marketController.text,
                      'password': passwordController.text,
                    }),
                  );
                  final data = json.decode(response.body);
                  if (response.statusCode == 200) {
                    print('Login successful');
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Homescreen()),
                  );
                  } else if (response.statusCode == 401) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Login Failed'),
                        content: Text('Invalid credentials. Please try again.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Login Failed'),
                        content: Text('${data['error']}\nStatus: ${response.statusCode}'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                },
                icon: const Icon(Icons.login),
                label: const Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> signup(String name, String market, String password) async {
  final url = Uri.parse('http://localhost:5000/signup');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'name': name,
      'market_name': market,
      'password': password,
    }),
  );

  if (response.statusCode == 201) {
    print('Signup successful');
  } else {
    print('Signup failed: ${response.body}, ${response.statusCode}');
  }
}