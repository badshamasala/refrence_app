import 'package:aayu/model/model.dart';
import 'package:get/state_manager.dart';

class WellnessAndYouController extends GetxController {
  late OnboardAssessmentModelAssessment wellnessAssessment;
  WellnessAndYouController(OnboardAssessmentModelAssessment assessment) {
    wellnessAssessment = assessment;
    update();
  }

  toggleSelection(index) {
    wellnessAssessment.options![index]!.selected = !wellnessAssessment.options![index]!.selected!;
    update();
  }
}
