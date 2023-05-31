import 'package:aayu/view/shared/shared.dart';
import 'package:get/get.dart';

import '../../../model/model.dart';
import '../../../services/psychology.service.dart';

class PsychologyController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<UserPsychologyDetailsModel?> userPsychologyDetails =
      UserPsychologyDetailsModel().obs;

  UserPsychologyJournalLogsModel? journalEntries =
      UserPsychologyJournalLogsModel();
  PsychologyRandomJournalModel? randomJournal = PsychologyRandomJournalModel();
  

  getUserPsychologyDetails() async {
    try {
      isLoading(true);
      UserPsychologyDetailsModel? response = await PsychologyService()
          .getUserPsychologyDetails(globalUserIdDetails?.userId ?? "");
      if (response != null && response.selectedPackage != null) {
        userPsychologyDetails.value = response;
      } else {
        userPsychologyDetails.value = null;
      }
    } catch (exp) {
      print(exp);
    } finally {
      isLoading(false);
    }
  }

  startUserPsychologyPlan(String packageId, String paymentOrderId) async {
    bool isStarted = false;
    try {
      dynamic postData = {
        "selectedPackage": {
          "packageId": packageId,
          "paymentOrderId": paymentOrderId
        }
      };
      isStarted = await PsychologyService()
          .startUserPsychology(globalUserIdDetails?.userId ?? "", postData);
    } catch (exp) {
      print(exp);
    } finally {}
    return isStarted;
  }

  extendPsychologyPlan(String packageId, String paymentOrderId) async {
    bool isExtended = false;
    try {
      dynamic postData = {
        "selectedPackage": {
          "packageId": packageId,
          "paymentOrderId": paymentOrderId
        }
      };
      isExtended = await PsychologyService()
          .extendPsychologyPlan(globalUserIdDetails?.userId ?? "", postData);
    } catch (exp) {
      print(exp);
    } finally {}
    return isExtended;
  }

  updateConsent() async {
    bool isUpdated = false;
    try {
      dynamic postData = {
        "userPsychologyMasterId":
            userPsychologyDetails.value?.userPsychologyMasterId ?? "",
      };
      isUpdated = await PsychologyService()
          .updateConsent(globalUserIdDetails?.userId ?? "", postData);
      if (isUpdated == true) {
        getUserPsychologyDetails();
      }
    } catch (exp) {
      print(exp);
    } finally {}
    return isUpdated;
  }

  getJournalEntries() async {
    try {
      UserPsychologyJournalLogsModel? response = await PsychologyService()
          .getJournalEntries(globalUserIdDetails?.userId ?? "");
      if (response != null &&
          response.journalLogs != null &&
          response.journalLogs!.isNotEmpty) {
        journalEntries = response;
      } else {
        journalEntries = null;
      }
    } catch (exp) {
      print(exp);
    } finally {
      update(["JournalEntries"]);
    }
  }

  getRandomJournal() async {
    try {
      PsychologyRandomJournalModel? response = await PsychologyService()
          .getRandomJournal(globalUserIdDetails?.userId ?? "");
      if (response != null && response.journal != null) {
        randomJournal = response;
      } else {
        randomJournal = null;
      }
    } catch (exp) {
      print(exp);
    } finally {
      update(["JournalEntry"]);
    }
  }

  submitJournalAnswer(String answer) async {
    bool isUpdated = false;
    try {
      dynamic postData = {
        "journalId": randomJournal?.journal?.journalId ?? "",
        "answer": answer,
      };
      isUpdated = await PsychologyService()
          .submitJournalAnswer(globalUserIdDetails?.userId ?? "", postData);
      if (isUpdated == true) {
        getJournalEntries();
      }
    } catch (exp) {
      print(exp);
    } finally {}
    return isUpdated;
  }
}
