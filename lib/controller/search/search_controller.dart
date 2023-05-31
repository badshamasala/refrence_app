import 'package:aayu/model/search/author.details.model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/artist/artist.followed.response.model.dart';
import '../../model/content/content.details.categories.response.model.dart';
import '../../model/grow/grow.page.content.model.dart';
import '../../model/search/search.recommendation.model.dart';

class SearchController extends GetxController with GetTickerProviderStateMixin {
  Rx<AuthorDetailsModel?> authorDetails = (null as AuthorDetailsModel).obs;
  Rx<TextEditingController> searchTextEditingController =
      TextEditingController().obs;
  Rx<SearchRecomendationModel?> searchRecommendation =
      SearchRecomendationModel().obs;

  late TabController tabController;
  RxList<String> recentSearchList = <String>[].obs;

  Rx<ContentDetailsCategoriesResponse?> searchResults =
      (null as ContentDetailsCategoriesResponse).obs;
  RxList<SearchRecomendationModelContentTypesItems> selectedTypes =
      <SearchRecomendationModelContentTypesItems>[].obs;
  RxList<SearchRecomendationModelContentDurationItems> selectedDuration =
      <SearchRecomendationModelContentDurationItems>[].obs;
  RxList<ContentMetaDataTags> selectedTags = <ContentMetaDataTags>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    try {
      isLoading(true);
      searchRecommendation.value =
          await GrowService().getSearchMetaData(globalUserIdDetails?.userId);
      recentSearchList.value = await HiveService().returnRecentSearchList();
    } catch (err) {
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  void setSearchText(String text) {
    searchTextEditingController.value.text = text;
    update();
  }

  void clearSearchText() {
    searchTextEditingController.value.text = '';
    update();
  }

  void setTypes(SearchRecomendationModelContentTypesItems type) {
    int index = selectedTypes
        .indexWhere((element) => element.contentType == type.contentType);
    if (index == -1) {
      if (searchRecommendation.value!.contentTypes!.maxSelect != null &&
          selectedTypes.length >=
              searchRecommendation.value!.contentTypes!.maxSelect!) {
        selectedTypes.removeAt(0);
      }
      selectedTypes.add(type);
    } else {
      selectedTypes.removeAt(index);
    }
    update();
  }

  void setDurations(SearchRecomendationModelContentDurationItems duration) {
    int index = selectedDuration.indexWhere((element) =>
        element.duration == duration.duration &&
        element.compare == duration.compare &&
        element.type == duration.type);
    if (index == -1) {
      if (searchRecommendation.value!.contentDuration!.maxSelect != null &&
          selectedDuration.length >=
              searchRecommendation.value!.contentDuration!.maxSelect!) {
        selectedDuration.removeAt(0);
      }

      selectedDuration.add(duration);
    } else {
      selectedDuration.removeAt(index);
    }
    update();
  }

  void setTags(ContentMetaDataTags tag) {
    int index = selectedTags.indexWhere((element) =>
        element.displayTagId == tag.displayTagId &&
        element.displayTag == element.displayTag);
    if (index == -1) {
      if (searchRecommendation.value!.tags!.maxSelect != null &&
          selectedTags.length >= searchRecommendation.value!.tags!.maxSelect!) {
        selectedTags.removeAt(0);
      }
      selectedTags.add(tag);
    } else {
      selectedTags.removeAt(index);
    }
    update();
  }

  nullSearchResults() {
    searchResults.value = null;
  }

  clearAllFilters() {
    selectedTypes.value = [];
    selectedDuration.value = [];
    selectedTags.value = [];
  }

  Future<void> removeFromRecentSearchList(int index) async {
    recentSearchList.value =
        await HiveService().removeFromRecentSearchList(index);
    update();
  }

  Future<void> getAuthorDetails(String authorId) async {
    isLoading(true);
    try {
      Map<String, dynamic> postData = {
        "data": {"authorId": authorId}
      };
      AuthorDetailsModel? response = await GrowService()
          .getAuthorDetails(globalUserIdDetails?.userId, postData);
      authorDetails.value = response;
      ContentDetailsCategoriesResponse contentDetailsCategoriesResponse =
          ContentDetailsCategoriesResponse();
      contentDetailsCategoriesResponse.categories = response!.content;
      searchResults.value = contentDetailsCategoriesResponse;
      tabController = TabController(
          length: searchResults.value!.categories!.length, vsync: this);
    } catch (err) {
      rethrow;
    } finally {
      isLoading(false);
    }
    return;
  }

  Future<void> getSearchResultsFromTag(ContentMetaDataTags tag) async {
    isLoading(true);
    try {
      Map<String, dynamic> postData = {};
      postData = {
        "data": {
          "tags": [tag.toJson()]
        }
      };
      ContentDetailsCategoriesResponse? response = await GrowService()
          .getSearchResultsFromTag(globalUserIdDetails!.userId ?? "", postData);
      if (response != null &&
          response.categories != null &&
          response.categories!.isNotEmpty) {
        searchResults.value = response;
        tabController = TabController(
            length: searchResults.value!.categories!.length, vsync: this);
        EventsService().sendEvent("Content_Tag_Search", {
          "tag": tag.displayTag,
          "tag_id": tag.displayTagId,
          "user_id": globalUserIdDetails!.userId,
        });
      } else {
        searchResults.value = null;
        EventsService().sendEvent("Content_Tag_No_Data", {
          "tag": tag.displayTag,
          "tag_id": tag.displayTagId,
          "user_id": globalUserIdDetails!.userId,
        });
      }
    } catch (err) {
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  Future<void> getSearchResults() async {
    isLoading(true);
    try {
      String text = searchTextEditingController.value.text.trim();
      Map<String, dynamic> postData = {};
      postData = {
        "data": {
          "topic": text,
          "type": selectedTypes.value.map((e) => e.toJson()).toList(),
          "length": selectedDuration.value.map((e) => e.toJson()).toList(),
          "tags": selectedTags.value.map((e) => e.toJson()).toList()
        }
      };
      ContentDetailsCategoriesResponse? response = await GrowService()
          .getSearchResults(globalUserIdDetails?.userId, postData);
      if (response != null &&
          response.categories != null &&
          response.categories!.isNotEmpty) {
        searchResults.value = response;
        tabController = TabController(
            length: searchResults.value!.categories!.length, vsync: this);
        if (text.isNotEmpty) {
          recentSearchList.value =
              await HiveService().addToRecentSearches(text);
          update();
        }
      } else {
        searchResults.value = null;
      }
    } catch (err) {
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  Future<void> followArtist(String artistid, bool isFollowed) async {
    if (globalUserIdDetails?.userId == null) {
      userLoginDialog({"screenName": "ARTIST_DETAILS", "artistId": artistid});
      return;
    }
    try {
      FollowArtistResponse? response = await GrowService()
          .followArtist(globalUserIdDetails!.userId!, artistid, isFollowed);
      isLoading(true);
      if (response != null) {
        authorDetails.value!.details!.isFollowed = isFollowed;
        if (response.followers != null && response.followers!.isNotEmpty) {
          authorDetails.value!.details!.follower = response.followers;
        }
      }
      isLoading(false);
    } finally {}
  }

  checkIsValid() {
    bool isValid = false;
    if (searchTextEditingController.value.text.isNotEmpty) {
      isValid = true;
    } else if (selectedTypes.value.isNotEmpty) {
      isValid = true;
    } else if (selectedDuration.value.isNotEmpty) {
      isValid = true;
    } else if (selectedTags.value.isNotEmpty) {
      isValid = true;
    }
    return isValid;
  }
}
