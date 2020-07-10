import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:momentum/momentum.dart';
import 'package:momentum_label_manager/components/font_awesome_map.dart';
import 'package:momentum_label_manager/domain/labels/label_index_controller.dart';
import 'package:momentum_label_manager/domain/labels/label_index_model.dart';
import 'package:momentum_label_manager/domain/labels/label_manage_controller.dart';
import 'package:momentum_label_manager/screens/index_screen.dart';
import 'package:momentum_label_manager/screens/label_manager_add_screen.dart';
import 'package:momentum_label_manager/screens/label_manager_update_screen.dart';
import 'package:momentum_label_manager/widgets/labels/label_list_card.dart';

class LabelManagerScreen extends StatefulWidget {
  _LabelManagerScreenState createState() => _LabelManagerScreenState();
}

class _LabelManagerScreenState extends MomentumState<LabelManagerScreen> {
  LabelIndexController indexController;
  LabelManageController labelManageController;

  @override
  void initMomentumState() {
    super.initMomentumState();
    indexController = Momentum.controller<LabelIndexController>(context);
    labelManageController = Momentum.controller<LabelManageController>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.arrowLeft),
          onPressed: () => Router.goto(context, IndexScreen),
        ),
        title: Text("Manage Labels"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(FontAwesomeIcons.plus),
        onPressed: () {
          labelManageController.setFromLabelData();
          Router.goto(context, LabelManagerAddScreen);
        },
      ),
      body: MomentumBuilder(
        controllers: [LabelIndexController],
        builder: (context, snapshot) {
          var model = snapshot<LabelIndexModel>();
          if (model.loadingResults) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: ReorderableListView(
              children: List.generate(model.labels.length, (index) {
                var label = indexController.model.labels[index];
                return Dismissible(
                  onDismissed: (dir) {
                    if (label.labelDefault == 1) {
                      FlutterToast(context).showToast(
                        child: Text("You cannot delete the default label"),
                        toastDuration: Duration(seconds: 3),
                        gravity: ToastGravity.CENTER,
                      );
                      indexController.getLabels();
                    } else {
                      indexController.deleteLabel(label);
                    }
                  },
                  key: Key("${label.id}"),
                  child: LabelListCard(
                    title: label.labelName,
                    icon: FaMap[label.labelIcon] ?? null,
                    editCallback: () {
                      labelManageController.setFromLabelData(label);
                      Router.goto(context, LabelManagerUpdateScreen);
                    },
                  ),
                );
              }),
              onReorder: (oldIdx, newIdx) {
                indexController.reorderLabels(oldIdx, newIdx);
              },
            ),
          );
        },
      ),
    );
  }
}
