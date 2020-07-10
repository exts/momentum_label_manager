import 'package:momentum_label_manager/abstract_data_object.dart';

/// I like momentum's models, but it's hard coupled with the controller
/// which makes it hard to create an empty object from a new instance when
/// creating new labels on the fly. So separating this from the momentum model
/// makes it much easier than adding a way to convert it to and from a momentum
/// model made my life easier even though I have a ton of boilerplate lol. I now
/// understand why generators exist in dart ;D
class LabelData extends DataObject<LabelData> {
  static const String TableName = "labels";
  static const List<String> ColumnNames = [
    "id",
    "label_name",
    "label_icon",
    "label_icon_offset",
    "label_order",
    "label_default",
  ];

  final int id;
  final String labelName;
  final String labelIcon;
  final double labelIconOffset;
  final int labelOrder;
  final int labelDefault;

  LabelData({
    this.id,
    this.labelName,
    this.labelIcon,
    this.labelIconOffset = 0,
    this.labelOrder,
    this.labelDefault = 0,
  });

  LabelData copyWith(Map data) {
    return LabelData(
      id: data["id"] ?? this.id,
      labelName: data["label_name"] ?? this.labelName,
      labelIcon: data["label_icon"] ?? this.labelIcon,
      labelIconOffset: data["label_icon_offset"] ?? this.labelIconOffset,
      labelOrder: data["label_order"] ?? this.labelOrder,
      labelDefault: data["label_default"] ?? this.labelDefault,
    );
  }

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

  static LabelData fromJson(Map data) {
    return LabelData(
      id: data["id"] ?? null,
      labelName: data["label_name"] ?? null,
      labelIcon: data["label_icon"] ?? null,
      labelIconOffset: data["label_icon_offset"] ?? null,
      labelOrder: data["label_order"] ?? null,
      labelDefault: data["label_default"] ?? null,
    );
  }
}
