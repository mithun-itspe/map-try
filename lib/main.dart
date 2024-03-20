import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled8/map/controller/map_controller.dart';
import 'package:untitled8/map/presentation/map_home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => MapHomeController(),
        child: const MapHomeScreen(),
      ),
    );
  }
}
