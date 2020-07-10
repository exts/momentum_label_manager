import 'package:momentum/momentum.dart';
import 'package:momentum_label_manager/domain/labels/label_data.dart';
import 'package:momentum_label_manager/domain/labels/label_index_model.dart';
import 'package:momentum_label_manager/domain/labels/label_repository.dart';

class LabelIndexController extends MomentumController<LabelIndexModel> {
  LabelRepository labelRepo;

  @override
  void bootstrap() {
    super.bootstrap();
    labelRepo = getService<LabelRepository>();
  }

  @override
  Future<void> bootstrapAsync() async {
    super.bootstrapAsync();

    // must be created if it doesn't exist before getting here
    await labelRepo.createDefaultLabelIfMissing();
    await getLabels();
  }

  @override
  LabelIndexModel init() {
    return LabelIndexModel(
      this,
      labels: List<LabelData>(),
      loadingResults: false,
    );
  }

  Future<void> getLabels() async {
    model.update(loadingResult: true);
    var labels = await labelRepo.getLabels();
    model.update(loadingResult: false, labels: labels);
  }

  void deleteLabel(LabelData label) {
    labelRepo.deleteLabel(label);

    var labels = List<LabelData>.from(model.labels);
    labels.remove(label);
    model.update(labels: labels);
  }

  void reorderLabels(int oldIndex, int newIndex) async {
    var labels = List<LabelData>.from(model.labels);
    var label = labels.removeAt(oldIndex);
    labels.insert(newIndex, label);
    model.update(labels: labels);

    var order = 0;
    for (var label in labels) {
      label = label.copyWith({"label_order": order});
      await labelRepo.saveLabel(label);
      order++;
    }
  }
}
