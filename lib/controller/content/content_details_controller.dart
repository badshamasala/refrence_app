import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class ContentDetailsController extends GetxController {
  Color appBarTextColor = AppColors.blackLabelColor;
  Rx<bool> isLoading = false.obs;
  Rx<bool> isCategoryLoading = false.obs;

  Rx<ContentDetailsResponse?> contentDetails = ContentDetailsResponse().obs;
  Rx<ContentDetailsCategoriesResponse?> contentCategoryDetails =
      ContentDetailsCategoriesResponse().obs;
  Rx<ContentReviewsModel?> contentReviews = ContentReviewsModel().obs;

  Future<void> getContentDetails(String contentId, bool fromRegister) async {
    try {
      isLoading.value = true;
      ContentDetailsResponse? response = await GrowService().getContentDetails(
          fromRegister ? "" : globalUserIdDetails?.userId, contentId);
      if (response != null) {
        contentDetails.value = response;
        if (contentDetails.value!.content!.metaData!.multiSeries == false) {
          getContentCategoryDetails(contentId, fromRegister);
        }
      }

      //Post as Recent Content
      if (globalUserIdDetails?.userId != null) {
        GrowService()
            .postRecentContent(globalUserIdDetails!.userId!, contentId);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getContentReviewDetails(String contentId) async {
    try {
      contentReviews.value = null;
      ContentReviewsModel? response = await GrowService()
          .getContentReviews(globalUserIdDetails?.userId, contentId);
      if (response != null) {
        contentReviews.value = response;
      }
    } finally {
      update();
    }
  }

  Future<ContentDetailsResponse?> returnContentDetails(String contentId) async {
    try {
      isLoading.value = true;
      ContentDetailsResponse? response = await GrowService()
          .getContentDetails(globalUserIdDetails!.userId, contentId);
      if (response != null) {
        return response;
      }
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  getContentCategoryDetails(String contentId, bool fromRegister) async {
    try {
      isCategoryLoading.value = true;
      ContentDetailsCategoriesResponse? response = await GrowService()
          .getContentCategoryDetails(
              fromRegister ? "" : globalUserIdDetails?.userId, contentId);
      if (response != null) {
        contentCategoryDetails.value = response;
      }
    } finally {
      isCategoryLoading.value = false;
      update();
    }
  }

  favouriteContent(String contentId, bool isFavourite) async {
    if (globalUserIdDetails?.userId == null) {
      userLoginDialog(
          {"screenName": "CONTENT_DETAILS", "contentId": contentId});
      return;
    }
    try {
      bool isSuccess = await GrowService().favouriteContent(
          globalUserIdDetails!.userId!, contentId, isFavourite, "grow");
      if (isSuccess == true) {
        contentDetails.value!.content!.isFavourite = isFavourite;
      }
    } finally {
      update();
    }
  }

  followArtist(String artistid, bool isFollowed, String contentId) async {
    if (globalUserIdDetails?.userId == null) {
      userLoginDialog(
          {"screenName": "CONTENT_DETAILS", "contentId": contentId});
      return;
    }
    try {
      FollowArtistResponse? response = await GrowService()
          .followArtist(globalUserIdDetails!.userId!, artistid, isFollowed);
      if (response != null) {
        contentDetails.value!.content!.artist!.isFollowed = isFollowed;
        if (response.followers != null && response.followers!.isNotEmpty) {
          contentDetails.value!.content!.artist!.followers = response.followers;
        }
        update(["FollowArtist", "FollowArtistCount"]);
      }
    } finally {}
  }
}
