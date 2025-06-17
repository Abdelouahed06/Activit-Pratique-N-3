import 'package:dwm_bot/pages/chabot.page.dart';
import 'package:dwm_bot/pages/login.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter/counter_bloc.dart';
import 'counter/counter_page.dart';
import 'pages/chabot_bloc.dart';
import 'pages/home_selection.page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeSelectionPage(),
      routes: {
        '/counter': (context) => BlocProvider(
              create: (_) => CounterBloc(),
              child: const CounterPage(),
            ),
        '/login': (context) => const LoginPage(),
        '/bot': (context) => BlocProvider(
              create: (_) => ChabotBloc(),
              child: const ChabotPage(),
            ),
      },
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.grey[100],
        useMaterial3: true,
      ),
    );
  }
}