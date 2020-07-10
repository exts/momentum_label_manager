import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:momentum/momentum.dart';
import 'package:momentum_label_manager/components/font_awesome_map.dart';
import 'package:momentum_label_manager/domain/labels/label_data.dart';
import 'package:momentum_label_manager/domain/labels/label_index_controller.dart';
import 'package:momentum_label_manager/domain/labels/label_manage_controller.dart';
import 'package:momentum_label_manager/screens/label_manager_screen.dart';

class LabelManagerAddScreen extends StatefulWidget {
  @override
  _LabelManagerAddScreenState createState() => _LabelManagerAddScreenState();
}

class _LabelManagerAddScreenState extends MomentumState<LabelManagerAddScreen> {
  ScrollController labelIconPickerController;

  LabelManageController controller;
  LabelIndexController indexController;

  @override
  void initMomentumState() {
    super.initMomentumState();
    controller = Momentum.controller<LabelManageController>(context);
    indexController = Momentum.controller<LabelIndexController>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.arrowLeft),
          onPressed: () {
            Router.goto(context, LabelManagerScreen);
          },
        ),
        title: Text("Add Label"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(FontAwesomeIcons.save),
        onPressed: () async {
          try {
            await controller.saveLabel();
            await indexController.getLabels();
            Router.goto(context, LabelManagerScreen);
          } catch (e) {
            FlutterToast(context).showToast(
              child: Text(e.toString().replaceAll("Exception:", "")),
              toastDuration: Duration(seconds: 3),
              gravity: ToastGravity.CENTER,
            );
          }
        },
      ),
      body: MomentumBuilder(
        controllers: [LabelManageController],
        builder: (context, snapshot) {
          return addForm(context);
        },
      ),
    );
  }

  Padding addForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              controller.getIcon(),
              RaisedButton(
                child: Text("Select Icon"),
                onPressed: () => dialog(context),
              ),
            ],
          ),
          Container(
            child: Divider(),
            margin: EdgeInsets.only(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Label Name",
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: "Enter a label name",
                ),
                onChanged: (value) => controller.updateName(value),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void dialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        var iconsList = controller.iconsList;
        labelIconPickerController = ScrollController(
            initialScrollOffset: controller.model.labelIconOffset);
        return AlertDialog(
          title: Text("Pick Icon"),
          content: Container(
            width: 400,
            height: 400,
            child: GridView.count(
              controller: labelIconPickerController,
              crossAxisCount: 7,
              children: List.generate(iconsList.length, (index) {
                return Center(
                  child: IconButton(
                    icon: Icon(
                      FaMap[iconsList[index]],
                      color: controller.currentIconColor(index),
                    ),
                    onPressed: () {
                      // the reason this works is because this only gets called
                      // after we create the scroll controller & after we set
                      // the scroll controller to the gridview else it would
                      // tell us to screw off with asserts. Also since momentum
                      // essentially calls setState with update, it also rebuilds
                      // the widget which is why the offset updates here too and
                      // we don't have to update the state again ;)
                      controller.selectIcon(
                          index, labelIconPickerController.offset);
                      Navigator.pop(context);
                    },
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
