import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';
import 'package:momentum_label_manager/domain/labels/label_index_controller.dart';
import 'package:momentum_label_manager/domain/labels/label_manage_controller.dart';
import 'package:momentum_label_manager/domain/labels/label_repository.dart';
import 'package:momentum_label_manager/screens/index_screen.dart';
import 'package:momentum_label_manager/screens/label_manager_add_screen.dart';
import 'package:momentum_label_manager/screens/label_manager_screen.dart';
import 'package:momentum_label_manager/screens/label_manager_update_screen.dart';

void main() {
  runApp(
    Momentum(
      disabledPersistentState: true,
      controllers: [
        LabelManageController(),
        LabelIndexController()..config(lazy: false),
      ],
      services: [
        Router([
          IndexScreen(),
          LabelManagerScreen(),
          LabelManagerAddScreen(),
          LabelManagerUpdateScreen(),
        ]),
        LabelRepository(),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Week In Review',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: IndexScreen(),
    );
  }
}
