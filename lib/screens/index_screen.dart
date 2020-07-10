import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:momentum/momentum.dart';
import 'package:momentum_label_manager/screens/label_manager_screen.dart';

class IndexScreen extends StatefulWidget {
  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends MomentumState<IndexScreen> {
  DateTime selectedDate;

  @override
  void initMomentumState() {
    super.initMomentumState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: menuDrawer(context),
      body: Center(
        child: Text("Open scaffold drawer to the left"),
      ),
    );
  }

  Widget menuDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () => Router.goto(context, LabelManagerScreen),
            child: ListTile(
              title: Text("Manage Labels"),
              leading: Icon(FontAwesomeIcons.edit),
            ),
          ),
        ],
      ),
    );
  }
}
