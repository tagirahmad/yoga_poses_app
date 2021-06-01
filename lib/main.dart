import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:teenyTinyOm/app/modules/home/home_view.dart';

import 'app/models/pose.dart';

Future<void> initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  await Hive.initFlutter();
  Hive.registerAdapter<Pose>(PoseAdapter());
  await Hive.openBox<Pose>('poses');
}

void main() async {
  await initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TeenyTinyOm',
      home: HomeView(),
    );
  }
}
