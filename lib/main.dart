import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yogya_blusuk/Presentation/Screens/login_screen.dart';
import 'package:yogya_blusuk/Presentation/Screens/place_screen.dart';
import 'package:yogya_blusuk/Data/Repositories/api_repositories.dart';
import 'package:yogya_blusuk/Data/Datasources/api_datasource.dart';


Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox('userBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage(accountRepository: AccountRepositoryImpl(ApiDataSource())),
      // PlacesScreen(placeRepository: PlaceRepositoryImpl(ApiDataSource())),
    );
  }
}

