import 'package:dexter_todo/screen/list/todo_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey.shade200,
        textTheme: GoogleFonts.poppinsTextTheme()
      ),
      themeMode: ThemeMode.light,
      home: const TodoListScreen(),
    );
  }
}
