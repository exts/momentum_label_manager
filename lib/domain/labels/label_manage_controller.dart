import 'package:flutter/material.dart';
import 'package:momentum_label_manager/components/font_awesome_map.dart';
import 'package:momentum_label_manager/domain/labels/label_controller.dart';
import 'package:momentum_label_manager/domain/labels/label_data.dart';
import 'package:momentum_label_manager/domain/labels/label_model.dart';
import 'package:momentum_label_manager/domain/labels/label_repository.dart';

class LabelManageController extends LabelController {
  LabelRepository labelRepo;

  final List<String> iconsList = FaMap.keys.toList();

  Widget getIcon() {
    var icon = FaMap[model.labelIcon] ?? null;
    return icon != null ? Icon(icon) : Container();
  }

  Color currentIconColor(int index) =>
      iconsList[index] == model.labelIcon ? Colors.lightBlue : Colors.black;

  @override
  void bootstrap() {
    super.bootstrap();
    labelRepo = getService<LabelRepository>();
  }

  @override
  LabelModel init() {
    return LabelModel(
      this,
      // i wanted to remember where the labels were in the scroll controller
      labelIconOffset: 0,
    );
  }

  void updateName(String labelName) => model.update(labelName: labelName);

  void selectIcon(int index, double offset) {
    model.update(
      iconName: iconsList[index] ?? null,
      iconOffset: offset,
    );
  }

  /// This is a trick for resetting the manage controller because momentum
  /// keeps the state of all controllers once they are created. All data set
  /// in a controller stays the same throughout your apps life time until you
  /// change it.
  ///
  /// So what we did here is when we add a new item we don't pass
  /// anything before we redirect the user to the create route. If we want to
  /// edit a label, we pass the label data directly from the index list to the
  /// manager controller for editing and we save it. Since it has all the data
  /// and id data set. This I believe is how momentum was meant to work and that
  /// was the biggest hurdle I had to udnerstand before I figured this out.
  void setFromLabelData([LabelData data]) {
    var label = data ?? LabelData();
    model.update(
      id: label.id,
      labelName: label.labelName,
      iconName: label.labelIcon,
      iconOffset: label.labelIconOffset,
      labelOrder: label.labelOrder,
      labelDefault: label.labelDefault,
      // null instead of previously set value, has nothing to do w/ momentum
      useDefault: false,
    );
  }

  Future<void> saveLabel() async {
    if (model.labelName == null || model.labelName.trim().isEmpty) {
      throw Exception("Please provide a label name");
    }

    if (model.id == null) {
      var order = await labelRepo.getLatestLabelOrder();
      model.update(labelOrder: order + 1);
    }

    await labelRepo.saveLabel(model.toDataObject());
  }
}
