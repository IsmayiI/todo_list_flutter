import 'package:flutter/material.dart';
import 'package:todo_list/ui/navigation/navigation.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme:
            AppBarTheme(backgroundColor: Colors.blue, centerTitle: true),
        useMaterial3: false,
      ),
      routes: Navigation.routes,
      onGenerateRoute: Navigation.onGenerateRoute,
      initialRoute: Navigation.initialRoute,
    );
  }
}
