import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:momentum/momentum.dart';
import 'package:momentum_label_manager/components/font_awesome_map.dart';
import 'package:momentum_label_manager/domain/labels/label_index_controller.dart';
import 'package:momentum_label_manager/domain/labels/label_manage_controller.dart';
import 'package:momentum_label_manager/screens/label_manager_screen.dart';

class LabelManagerUpdateScreen extends StatefulWidget {
  @override
  _LabelManagerUpdateScreenState createState() =>
      _LabelManagerUpdateScreenState();
}

class _LabelManagerUpdateScreenState
    extends MomentumState<LabelManagerUpdateScreen> {
  ScrollController labelIconPickerController;
  String labelName;
  TextEditingController nameTextEditingController;

  LabelManageController controller;
  LabelIndexController indexController;

  @override
  void initMomentumState() {
    super.initMomentumState();
    controller = Momentum.controller<LabelManageController>(context);
    indexController = Momentum.controller<LabelIndexController>(context);

    nameTextEditingController = TextEditingController();

    if (controller.model.labelName != null) {
      nameTextEditingController.text = controller.model.labelName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MomentumBuilder(
      controllers: [LabelManageController],
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Update Label"),
            leading: IconButton(
              icon: Icon(FontAwesomeIcons.arrowLeft),
              onPressed: () {
                Router.goto(context, LabelManagerScreen);
              },
            ),
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
          body: updateForm(context),
        );
      },
    );
  }

  Padding updateForm(BuildContext context) {
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
                controller: nameTextEditingController,
                decoration: InputDecoration(
                  hintText: "Enter a label name",
                ),
                onChanged: (value) => labelName = value,
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
                      // the widget which is why hte offset updates here too and
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
