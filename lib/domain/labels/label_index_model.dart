import 'package:momentum/momentum.dart';
import 'package:momentum_label_manager/domain/labels/label_data.dart';
import 'package:momentum_label_manager/domain/labels/label_index_controller.dart';

class LabelIndexModel extends MomentumModel<LabelIndexController> {
  final bool loadingResults;
  final List<LabelData> labels;

  LabelIndexModel(
    LabelIndexController controller, {
    this.loadingResults,
    this.labels,
  }) : super(controller);

  @override
  void update({bool loadingResult, List<LabelData> labels}) {
    LabelIndexModel(
      controller,
      loadingResults: loadingResult ?? this.loadingResults,
      labels: labels ?? this.labels,
    ).updateMomentum();
  }
}
