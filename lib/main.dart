import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'helpers/sql_helper.dart';
import 'pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var sqlHelper = SqlHelper();
  await sqlHelper.initDb();
  if (sqlHelper.db != null) {
    GetIt.I.registerSingleton<SqlHelper>(sqlHelper);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Easy POS',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 0, 87, 218),
        appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 0, 87, 218),
            foregroundColor: Colors.white),
        iconTheme: const IconThemeData(color: Colors.white),
        colorScheme: ColorScheme.fromSwatch(
          errorColor: Colors.red,
          backgroundColor: Colors.white,
        ),
      ),
      home: const HomePage(),
    );
  }
}
