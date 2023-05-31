import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:get/state_manager.dart';

class TestimonialController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<TestimonialResponse?> testimonialResponse = TestimonialResponse().obs;
  getTestimonials(DiseaseDetailsRequest diseaseIds) async {
    try {
      isLoading.value = true;
      TestimonialResponse? response =
          await HealingService().getTestimonials(diseaseIds);
      if (response != null) {
        testimonialResponse.value = response;
      }
    } finally {
      isLoading.value = false;
    }
  }
}
