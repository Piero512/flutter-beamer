import 'package:beamer_app/services/api_service.dart';
import 'package:beamer_app/ui/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(
          create: (ctx) => ApiService(),
        ),
      ],
      child: MaterialApp(
        title: 'Beamer Web Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: MainScreen(),
      ),
    );
  }
}
