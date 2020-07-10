import 'package:momentum/momentum.dart';
import 'package:momentum_label_manager/domain/labels/label_model.dart';

abstract class LabelController extends MomentumController<LabelModel> {
  @override
  LabelModel init();
}
