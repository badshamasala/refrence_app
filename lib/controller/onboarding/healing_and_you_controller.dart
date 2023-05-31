import 'package:aayu/model/model.dart';
import 'package:get/state_manager.dart';

class HealingAndYouController extends GetxController {
  late OnboardAssessmentModelAssessment healingAssessment;
  HealingAndYouController(OnboardAssessmentModelAssessment assessment) {
    healingAssessment = assessment;
    update();
  }

  toggleSelection(index) {
    healingAssessment.options![index]!.selected =
        !healingAssessment.options![index]!.selected!;
    update();
  }
}
