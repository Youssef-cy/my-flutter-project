import 'package:flutter/material.dart';
import 'package:flutter_application_1/loginscreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://wdrjkcdxobrxpxomhvru.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndkcmprY2R4b2JyeHB4b21odnJ1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkyMTk4MzUsImV4cCI6MjA2NDc5NTgzNX0.bOIrdYtNeWJu1hl4OOyq9RMpMSwTdzJu6cFkmGSJSmU',
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light),
      home: const Loginscreen(),
    );
  }
}
