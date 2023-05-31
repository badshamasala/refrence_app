import 'package:get/get.dart';
import '../../model/you_tracker/you_tracker_model.dart';
import '../../services/you.tracker.service.dart';

class YouTrackerController extends GetxController {
  Rx<bool> isLoading = false.obs;

  Rx<UserTrackers?> youTrackerList = UserTrackers().obs;
  List<UserTrackersDataActiveTrackers?>? activeTrackersCopy;
  List<UserTrackersDataActiveTrackers?>? trackerListCopy;
  Rx<bool> youTracker = true.obs;
  Rx<bool> selectYourTracker = true.obs;
  @override
  void onInit() async {
    await getYouTrackerList();
    super.onInit();
  }

  Future<void> getYouTrackerList() async {
    try {
      isLoading.value = true;
      UserTrackers? response = await YouTrackerService().getYouTrackersList();
      if (response != null) {
        youTrackerList.value = response;
      } else {
        youTrackerList.value = null;
      }
    } catch (exp) {
      print(exp);
    } finally {
      isLoading.value = false;
      update();
    }
  }

  final listOfTrackerId = RxList<String>();

  void sennID() {
    final newList = youTrackerList.value?.data?.activeTrackers
        ?.map((e) => e?.trackerId.toString())
        .whereType<String>()
        .toList();
    listOfTrackerId.assignAll(newList ?? []);
    
  }

  addMethod(index) {
    activeTrackersCopy!.add(trackerListCopy![index]);
    trackerListCopy!.removeAt(index);

    
    updateVisibility();
    update();
  }

  void updateVisibility() {
    if (trackerListCopy?.isEmpty == true) {
      youTracker.value = false;
    } else {
      youTracker.value = true;
    } if (activeTrackersCopy?.isEmpty == true) {
      selectYourTracker.value = false;
    } else {
      selectYourTracker.value = true;
    }
    update();
  }

  removeMethod(index) {
    trackerListCopy!.add(activeTrackersCopy![index]);
    activeTrackersCopy!.removeAt(index);
    
    updateVisibility();
    update();
  }
}
