import '../grow/grow.page.content.model.dart';

///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///

class AuthorDetailsModelDetails {
/*
{
  "authorId": "623c63-79af00707-3b0786br5",
  "authorName": "Loula Taylor",
  "image": "https://stg-content.aayu.live/Affirmations/artistimage/images3x/LoulaTaylor.png",
  "rating": 4.1,
  "description": null,
  "location": null,
  "follower": "4",
  "follow": false
} 
*/

  String? authorId;
  String? authorName;
  String? image;
  double? rating;
  String? description;
  String? location;
  String? follower;
  bool? isFollowed;

  AuthorDetailsModelDetails({
    this.authorId,
    this.authorName,
    this.image,
    this.rating,
    this.description,
    this.location,
    this.follower,
    this.isFollowed,
  });
  AuthorDetailsModelDetails.fromJson(Map<String, dynamic> json) {
    authorId = json['authorId']?.toString();
    authorName = json['authorName']?.toString();
    image = json['image']?.toString();
    rating = json['rating']?.toDouble();
    description = json['description']?.toString();
    location = json['location']?.toString();
    follower = json['follower']?.toString();
    isFollowed = json['isFollowed'] ?? false;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['authorId'] = authorId;
    data['authorName'] = authorName;
    data['image'] = image;
    data['rating'] = rating;
    data['description'] = description;
    data['location'] = location;
    data['follower'] = follower;
    data['isFollowed'] = isFollowed;
    return data;
  }
}

class AuthorDetailsModel {
/*
{
 "details": {
    "authorId": "623c63-79af00707-3b0786br5",
    "authorName": "Loula Taylor",
    "image": "https://stg-content.aayu.live/Affirmations/artistimage/images3x/LoulaTaylor.png",
    "rating": 4.1,
    "description": null,
    "location": null,
    "follower": "4",
    "follow": false
  },
  "content": [
    {
      "categoryId": "abc281d0-c20c-11ec-ad9e-318b6393e9c5",
      "categoryName": "Meditation",
      "showMore": false,
      "bgColor": "#FFFFFF",
      "medaDataBgColor": "#F1F1F1",
      "content": [
        {
          "contentId": "8f2d1569-0dfe-48dd-a856-7f015b9db1be",
          "contentName": "Gentle Body Scan",
          "contentImage": "https://stg-content.aayu.live/Meditations/Audio/280722/GentleBodyScan/GentleBodyScan_966x543.jpg",
          "contentType": "Audio",
          "contentPath": "https://stg-content.aayu.live/Meditations/Audio/280722/GentleBodyScan/GentleBodyScan.mp3",
          "playBGImage": "https://stg-content.aayu.live/Meditations/Audio/280722/GentleBodyScan/GentleBodyScan_1125x2436.jpg",
          "isFavourite": true,
          "artist": {
            "artistId": "623c63-79af00707-3b0786br5",
            "artistName": "Loula Taylor",
            "artistImage": "https://stg-content.aayu.live/Affirmations/artistimage/images3x/LoulaTaylor.png"
          },
          "metaData": {
            "duration": "10 min",
            "rating": 4.4,
            "views": "5k",
            "language": "English",
            "tags": [
              {
                "displayTagId": "1",
                "displayTag": "Self-Observation"
              }
            ],
            "isPremium": false,
            "contentTag": "Beginners Meditation"
          }
        }
      ]
    }
  ]
} 
*/

  AuthorDetailsModelDetails? details;
  List<ContentCategories?>? content;

  AuthorDetailsModel({
    this.details,
    this.content,
  });
  AuthorDetailsModel.fromJson(Map<String, dynamic> json) {
    details = (json['details'] != null)
        ? AuthorDetailsModelDetails.fromJson(json['details'])
        : null;
    if (json['content'] != null) {
      final v = json['content'];
      final arr0 = <ContentCategories>[];
      v.forEach((v) {
        arr0.add(ContentCategories.fromJson(v));
      });
      content = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (details != null) {
      data['details'] = details!.toJson();
    }
    if (content != null) {
      final v = content;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data['content'] = arr0;
    }
    return data;
  }
}
