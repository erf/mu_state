import 'package:example/home_page/home_page.dart';
import 'package:example/home_page/home_page_logic.dart';
import 'package:example/home_page/home_page_state.dart';
import 'package:flutter/material.dart';
import 'package:mu_state/mu_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mu_state Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MuProvider<HomePageLogic, HomePageState>(
        logic: HomePageLogic(),
        child: const HomePage(),
      ),
    );
  }
}
