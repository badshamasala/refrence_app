import 'package:aayu/model/you_tracker/you_tracker_model.dart';
import 'package:aayu/services/request.id.service.dart';
import 'package:aayu/view/shared/shared.dart';
import '../model/you_tracker/you_tracker_post_modal.dart';
import 'http.service.dart';

const String trackerServiceName = "tracker-service";

class YouTrackerService {
  Future<UserTrackers?> getYouTrackersList() async {
    dynamic response = await httpGet(
        trackerServiceName, 'v1/tracker/list?requestId=${getRequestId()}',
        customHeaders: {
          "x-user-id": globalUserIdDetails?.userId
              
        });
    if (response != null && response["success"] == true) {
      UserTrackers youTrackerResponse = UserTrackers();
      youTrackerResponse = UserTrackers.fromJson(response);
      return youTrackerResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<UserTrackersPostModal?> postYouTrackersList(
      List<String> trackerId) async {
    dynamic response = await httpPost(
        trackerServiceName, 'v1/tracker/list?requestId=${getRequestId()}', {
      "data": {"trackers": trackerId}
    },
        customHeaders: {
          "x-user-id": globalUserIdDetails?.userId
              
        });
    if (response != null && response["success"] == true) {
      UserTrackersPostModal postlistTrackers = UserTrackersPostModal();
      postlistTrackers = UserTrackersPostModal.fromJson(response);
      return postlistTrackers;
    } else {
      showError(response["error"]);
      return null;
    }
  }
}
