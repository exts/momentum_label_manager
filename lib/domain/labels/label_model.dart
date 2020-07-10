import 'package:momentum/momentum.dart';
import 'package:momentum_label_manager/domain/labels/label_controller.dart';
import 'package:momentum_label_manager/domain/labels/label_data.dart';

class LabelModel extends MomentumModel<LabelController> {
  final int id;
  final String labelName;
  final String labelIcon;
  final double labelIconOffset;
  final int labelOrder;
  final int labelDefault;

  LabelModel(
    LabelController controller, {
    this.id,
    this.labelName,
    this.labelIcon,
    this.labelIconOffset = 0,
    this.labelOrder,
    this.labelDefault = 0,
  }) : super(controller);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "label_name": labelName,
      "label_icon": labelIcon,
      "label_icon_offset": labelIconOffset,
      "label_order": labelOrder,
      "label_default": labelDefault,
    };
  }

  LabelData toDataObject() {
    return LabelData(
      id: id,
      labelName: labelName,
      labelIcon: labelIcon,
      labelIconOffset: labelIconOffset,
      labelOrder: labelOrder,
      labelDefault: labelDefault,
    );
  }

  @override
  void update({
    int id,
    String labelName,
    String iconName,
    double iconOffset,
    int labelOrder,
    int labelDefault,
    bool useDefault,
  }) {
    useDefault = useDefault ?? true;
    LabelModel(
      controller,
      id: id ?? _dOn(useDefault, this.id),
      labelName: labelName ?? _dOn(useDefault, this.labelName),
      labelIcon: iconName ?? _dOn(useDefault, this.labelIcon),
      labelIconOffset: iconOffset ?? _dOn(useDefault, this.labelIconOffset),
      labelOrder: labelOrder ?? _dOn(useDefault, this.labelOrder),
      labelDefault: labelDefault ?? _dOn(useDefault, this.labelDefault),
    ).updateMomentum();
  }

  // duplicate I know
  dynamic _dOn(bool useDefault, dynamic value) =>
      _defaultOrNull(useDefault, value);

  dynamic _defaultOrNull(bool useDefaultValue, dynamic defaultvalue) {
    return useDefaultValue ? defaultvalue : null;
  }
}
