import 'dart:io'; // Để kiểm tra hệ điều hành
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Import thư viện ffi
import 'providers/note_provider.dart';
import 'screens/home_page.dart';

void main() {
  // Kiểm tra nếu đang chạy trên Desktop (Windows/Linux/MacOS)
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Khởi tạo database factory cho desktop
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NoteProvider(),
      child: MaterialApp(
        title: 'Simple Note App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
