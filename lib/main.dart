import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'helpers/sql_helper.dart';
import 'pages/home.dart';

/*in progress: - product list page ui
               - the editing/updating part:
                                         1 - it doesn't display right away
                                         2 - some of the product fields are empty in editing form
                                         3 - it says product saved if you checked all the required fields on product,
                                           but there isn't categories, it just say it's added, it doesn't really add,
                                           it should display error
                                         4 - 
*/

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
          backgroundColor: Colors.white,
        ),
      ),
      home: const HomePage(),
    );
  }
}
