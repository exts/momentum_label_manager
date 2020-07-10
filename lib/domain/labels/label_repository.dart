import 'package:momentum/momentum.dart';
import 'package:momentum_label_manager/domain/labels/label_data.dart';
import 'package:momentum_label_manager/services/database_service.dart';

/// We turn this into a momentum service to just make it easier to
/// access from controllers. There's nothing really special to momentum services
/// besides that little fact of being able to access them from controllers
class LabelRepository extends MomentumService {
  LabelRepository();

  Future<void> createDefaultLabelIfMissing() async {
    var db = await DatabaseService.db;
    var result = await db.query(
      LabelData.TableName,
      columns: LabelData.ColumnNames,
      where: "label_default = ?",
      whereArgs: [1],
    );

    if (result.length == 0) {
      await saveLabel(
        LabelData(
          labelName: "Other",
          labelIcon: null,
          labelOrder: 0,
          labelDefault: 1,
        ),
      );
    }
  }

  Future<void> saveLabel(LabelData label) async {
    var data = Map<String, dynamic>.from(label.toJson());

    var db = await DatabaseService.db;
    if (label.id == null) {
      await db.insert(LabelData.TableName, data);
    } else {
      data.remove("id");
      await db.update(LabelData.TableName, data,
          where: "id = ?", whereArgs: [label.id]);
    }
  }

  Future<void> deleteLabel(LabelData label) async {
    var db = await DatabaseService.db;
    await db.delete(
      LabelData.TableName,
      where: "id = ?",
      whereArgs: [label.id],
    );
  }

  Future<int> getLatestLabelOrder() async {
    var db = await DatabaseService.db;
    var result = await db.query(LabelData.TableName,
        orderBy: "label_order DESC", limit: 1);

    if (result != null) {
      return result.first["label_order"] ?? 0;
    }

    return 0;
  }

  Future<List<LabelData>> getLabels() async {
    var db = await DatabaseService.db;
    var result =
        await db.query(LabelData.TableName, orderBy: "label_order ASC");

    if (result == null) return null;

    var labels = List<LabelData>();
    for (var label in result) {
      labels.add(LabelData.fromJson(label));
    }

    return labels;
  }
}
