import 'package:aayu/model/model.dart';
import 'package:aayu/model/search/author.details.model.dart';
import 'package:aayu/services/http.service.dart';
import 'package:aayu/view/shared/shared.dart';

import '../model/search/search.recommendation.model.dart';
import 'request.id.service.dart';

const String growServiceName = "grow-service";

class GrowService {
  Future<HomePageTopSectionResponse?> getHomePageTopContent(
      String? userId) async {
    dynamic response = await httpGet(
        growServiceName, 'v1/home/top?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      HomePageTopSectionResponse homePageTopSectionResponse =
          HomePageTopSectionResponse();
      homePageTopSectionResponse =
          HomePageTopSectionResponse.fromJson(response["data"]);
      return homePageTopSectionResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<HomePageContentResponse?> getHomePageContent(String userId) async {
    dynamic response = await httpGet(
        growServiceName, 'v1/home/content?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      HomePageContentResponse homePageContentResponse =
          HomePageContentResponse();
      homePageContentResponse =
          HomePageContentResponse.fromJson(response["data"]);
      return homePageContentResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<GrowPageContentResponse?> getGrowPageCategoryContent(
      String? userId, String categoryId) async {
    dynamic response = await httpGet(growServiceName,
        'v1/grow/category/$categoryId?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      GrowPageContentResponse growPageContentResponse =
          GrowPageContentResponse();
      growPageContentResponse =
          GrowPageContentResponse.fromJson(response["data"]);
      return growPageContentResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<GrowCategoriesResponse?> getGrowPageCategories(String? userId) async {
    dynamic response = await httpGet(
        growServiceName, 'v1/grow/categories?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      GrowCategoriesResponse growCategoriesResponse = GrowCategoriesResponse();
      growCategoriesResponse =
          GrowCategoriesResponse.fromJson(response["data"]);
      return growCategoriesResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<ContentDetailsResponse?> getContentDetails(
      String? userId, String contentId) async {
    dynamic response = await httpGet(growServiceName,
        'v1/content/details/$contentId?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId ?? ""});
    if (response != null && response["success"] == true) {
      ContentDetailsResponse contentDetailsResponse = ContentDetailsResponse();
      contentDetailsResponse =
          ContentDetailsResponse.fromJson(response["data"]);
      return contentDetailsResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<ContentDetailsCategoriesResponse?> getContentCategoryDetails(
      String? userId, String contentId) async {
    dynamic response = await httpGet(growServiceName,
        'v1/content/categories/$contentId?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId ?? ""});
    if (response != null && response["success"] == true) {
      ContentDetailsCategoriesResponse contentDetailsCategoriesResponse =
          ContentDetailsCategoriesResponse();
      contentDetailsCategoriesResponse =
          ContentDetailsCategoriesResponse.fromJson(response["data"]);
      return contentDetailsCategoriesResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<FavouritesContentResponse?> getFavouritesContent(String userId) async {
    dynamic response = await httpGet(
        growServiceName, 'v1/content/favourite?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      FavouritesContentResponse favouritesContentResponse =
          FavouritesContentResponse();
      favouritesContentResponse =
          FavouritesContentResponse.fromJson(response["data"]);
      return favouritesContentResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool> favouriteContent(String userId, String contentId,
      bool isFavourite, String contentType) async {
    dynamic response = await httpPost(
      growServiceName,
      'v1/content/favourite?requestId=${getRequestId()}',
      {
        "data": {
          "contentId": contentId,
          "favourite": isFavourite,
          "contentType": contentType
        }
      },
      customHeaders: {"x-user-id": userId},
    );
    if (response != null && response["success"] == true) {
      return true;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<ExpertsIFollowResponse?> getExpertsIFollow(String userId) async {
    dynamic response = await httpGet(
        growServiceName, 'v1/experts/followed?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      ExpertsIFollowResponse expertsIFollowResponse = ExpertsIFollowResponse();
      expertsIFollowResponse =
          ExpertsIFollowResponse.fromJson(response["data"]);
      return expertsIFollowResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<FollowArtistResponse?> followArtist(
      String userId, String artistId, bool isFollowed) async {
    dynamic response = await httpPost(
      growServiceName,
      'v1/experts/follow?requestId=${getRequestId()}',
      {
        "data": {
          "artistId": artistId,
          "follow": isFollowed,
        }
      },
      customHeaders: {"x-user-id": userId},
    );
    if (response != null && response["success"] == true) {
      FollowArtistResponse expertsIFollowResponse = FollowArtistResponse();
      expertsIFollowResponse = FollowArtistResponse.fromJson(response["data"]);
      return expertsIFollowResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<ContentCategories?> getRecentCategoryContent(String userId) async {
    dynamic response = await httpGet(
        growServiceName, 'v1/content/recent?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      if (response["data"] != null && response["data"]["details"] != null) {
        ContentCategories contentCategoriesResponse = ContentCategories();
        contentCategoriesResponse =
            ContentCategories.fromJson(response["data"]["details"]);
        return contentCategoriesResponse;
      } else {
        return null;
      }
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool> postRecentContent(String userId, String contentId) async {
    dynamic response = await httpPost(
        growServiceName, 'v1/content/recent?requestId=${getRequestId()}', {
      "data": {
        "contentId": contentId,
      }
    },
        customHeaders: {
          "x-user-id": userId
        });
    if (response != null && response["success"] == true) {
      return true;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<ContentCategories?> getViewAllContent(
      String? userId, String categoryId) async {
    dynamic response = await httpGet(
        growServiceName, 'v1/grow/view/$categoryId?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      if (response["data"] != null && response["data"]["details"] != null) {
        ContentCategories contentCategoriesResponse = ContentCategories();
        contentCategoriesResponse =
            ContentCategories.fromJson(response["data"]["details"]);
        return contentCategoriesResponse;
      }
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool> getContentRating(String userId, String contentId) async {
    dynamic response = await httpGet(growServiceName,
        'v1/content/rating/$contentId?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      return true;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<bool> postContentRating(String userId, String contentId,
      int contentRating, String comments) async {
    dynamic response = await httpPost(
        growServiceName, 'v1/content/rating?requestId=${getRequestId()}', {
      "data": {
        "contentId": contentId,
        "rating": contentRating,
        "comments": comments
      }
    },
        customHeaders: {
          "x-user-id": userId
        });
    if (response != null && response["success"] == true) {
      return true;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<bool> postContentCompletion(
      String userId, String contentId, int day, String programId) async {
    dynamic postData = {};

    if (day == -1) {
      postData = {
        "data": {
          "contentId": contentId,
          "programId": programId,
        }
      };
    } else {
      postData = {
        "data": {
          "contentId": contentId,
          "day": (day == -1) ? null : day,
          "programId": programId,
        }
      };
    }

    dynamic response = await httpPost(growServiceName,
        'v1/content/completion?requestId=${getRequestId()}', postData,
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      return true;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<YouMinutesSummaryResponse?> getMinutesSummary(String userId) async {
    dynamic response = await httpGet(
        growServiceName, 'v1/content/completion?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      YouMinutesSummaryResponse youMinutesSummaryResponse =
          YouMinutesSummaryResponse();
      youMinutesSummaryResponse =
          YouMinutesSummaryResponse.fromJson(response["data"]);
      return youMinutesSummaryResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<SearchRecomendationModel?> getSearchMetaData(
    String? userId,
  ) async {
    dynamic response = await httpGet(
        growServiceName, 'v1/content/search/meta?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      SearchRecomendationModel searchRecomendationModel =
          SearchRecomendationModel();
      searchRecomendationModel =
          SearchRecomendationModel.fromJson(response["data"]);
      return searchRecomendationModel;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<ContentDetailsCategoriesResponse?> getSearchResults(
      String? userId, Map<String, dynamic>? postData) async {
    dynamic response = await httpPost(growServiceName,
        'v1/content/search?requestId=${getRequestId()}', postData,
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      ContentDetailsCategoriesResponse contentDetailsCategoriesResponse =
          ContentDetailsCategoriesResponse();
      Map<String, dynamic> map = {};
      map["categories"] = response["data"]["searchContent"];
      contentDetailsCategoriesResponse =
          ContentDetailsCategoriesResponse.fromJson(map);
      return contentDetailsCategoriesResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<AuthorDetailsModel?> getAuthorDetails(
      String? userId, Map<String, dynamic>? postData) async {
    dynamic response = await httpPost(growServiceName,
        'v1/content/search/author?requestId=${getRequestId()}', postData,
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      AuthorDetailsModel authorDetailsModel = AuthorDetailsModel();
      authorDetailsModel = AuthorDetailsModel.fromJson(response["data"]);
      return authorDetailsModel;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<ContentDetailsCategoriesResponse?> getSearchResultsFromTag(
      String userId, Map<String, dynamic>? postData) async {
    dynamic response = await httpPost(growServiceName,
        'v1/content/search/tag?requestId=${getRequestId()}', postData,
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      ContentDetailsCategoriesResponse contentDetailsCategoriesResponse =
          ContentDetailsCategoriesResponse();
      Map<String, dynamic> map = {};
      map["categories"] = response["data"]["searchTag"];
      contentDetailsCategoriesResponse =
          ContentDetailsCategoriesResponse.fromJson(map);
      return contentDetailsCategoriesResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<ContentReviewsModel?> getContentReviews(
    String? userId,
    String contentId,
  ) async {
    dynamic response = await httpGet(growServiceName,
        'v1/content/review/$contentId/?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      ContentReviewsModel contentReviews = ContentReviewsModel();
      contentReviews = ContentReviewsModel.fromJson(response["data"]);
      return contentReviews;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<ContentReviewsModel?> getAllContentReviews(
    String? userId,
    String contentId,
  ) async {
    dynamic response = await httpGet(growServiceName,
        'v1/content/review/all/$contentId/?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      ContentReviewsModel contentReviews = ContentReviewsModel();
      contentReviews = ContentReviewsModel.fromJson(response["data"]);
      return contentReviews;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<ContentCategories?> searchContentByKeywords(
      String? userId, Map<String, dynamic>? postData) async {
    dynamic response = await httpPost(growServiceName,
        'v1/content/search/keywords?requestId=${getRequestId()}', postData,
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      if (response["data"] != null &&
          response["data"]["searchKeywords"] != null &&
          response["data"]["searchKeywords"][0] != null) {
        ContentCategories contentCategoriesResponse = ContentCategories();
        contentCategoriesResponse =
            ContentCategories.fromJson(response["data"]["searchKeywords"][0]);
        return contentCategoriesResponse;
      } else {
        return null;
      }
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<ContentCategories?> getRecommendedContent(
      String? userId, String category) async {
    dynamic response = await httpGet(growServiceName,
        'v1/content/recommended/$category?requestId=1${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      if (response["data"] != null &&
          response["data"]["categories"] != null &&
          response["data"]["categories"][0] != null) {
        ContentCategories contentCategoriesResponse = ContentCategories();
        contentCategoriesResponse =
            ContentCategories.fromJson(response["data"]["categories"][0]);
        return contentCategoriesResponse;
      } else {
        return null;
      }
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<ContentCategories?> getRandomAffirmation(String? userId) async {
    dynamic response = await httpGet(
        growServiceName, 'v1/content/affirmation?requestId=1${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      if (response["data"] != null &&
          response["data"]["details"] != null &&
          response["data"]["details"][0] != null) {
        ContentCategories contentCategoriesResponse = ContentCategories();
        contentCategoriesResponse =
            ContentCategories.fromJson(response["data"]["details"][0]);
        return contentCategoriesResponse;
      } else {
        return null;
      }
    } else {
      showError(response["error"]);
      return null;
    }
  }
}
