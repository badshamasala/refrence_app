import 'package:aayu/model/grow/grow.page.content.model.dart';

///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class HomePageContentResponseDetailsDailyRoutineContentMetaData {
/*
{
  "icon": "Play",
  "iconBGColor": "#FFFFFF",
  "iconColor": "#FFFFFF",
  "titleColor": "#FFFFFF",
  "descColor": "#FFFFFF"
} 
*/

  String? icon;
  String? iconBGColor;
  String? iconColor;
  String? titleColor;
  String? descColor;

  HomePageContentResponseDetailsDailyRoutineContentMetaData({
    this.icon,
    this.iconBGColor,
    this.iconColor,
    this.titleColor,
    this.descColor,
  });
  HomePageContentResponseDetailsDailyRoutineContentMetaData.fromJson(
      Map<String, dynamic> json) {
    icon = json['icon']?.toString();
    iconBGColor = json['iconBGColor']?.toString();
    iconColor = json['iconColor']?.toString();
    titleColor = json['titleColor']?.toString();
    descColor = json['descColor']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['icon'] = icon;
    data['iconBGColor'] = iconBGColor;
    data['iconColor'] = iconColor;
    data['titleColor'] = titleColor;
    data['descColor'] = descColor;
    return data;
  }
}

class HomePageContentResponseDetailsDailyRoutineContent {
/*
{
  "title": "Sleep Tracker",
  "desc": "Monitor your sleep for better insights",
  "duration": "1 Min",
  "metaData": {
    "icon": "Play",
    "iconBGColor": "#FFFFFF",
    "iconColor": "#FFFFFF",
    "titleColor": "#FFFFFF",
    "descColor": "#FFFFFF"
  },
  "image": "https://stg-content.aayu.live/dailyroutine/sleep.png",
  "accessType": "sleep"
} 
*/

  String? title;
  String? desc;
  String? duration;
  HomePageContentResponseDetailsDailyRoutineContentMetaData? metaData;
  String? image;
  String? accessType;

  HomePageContentResponseDetailsDailyRoutineContent({
    this.title,
    this.desc,
    this.duration,
    this.metaData,
    this.image,
    this.accessType,
  });
  HomePageContentResponseDetailsDailyRoutineContent.fromJson(
      Map<String, dynamic> json) {
    title = json['title']?.toString();
    desc = json['desc']?.toString();
    duration = json['duration']?.toString();
    metaData = (json['metaData'] != null)
        ? HomePageContentResponseDetailsDailyRoutineContentMetaData.fromJson(
            json['metaData'])
        : null;
    image = json['image']?.toString();
    accessType = json['accessType']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['desc'] = desc;
    data['duration'] = duration;
    if (metaData != null) {
      data['metaData'] = metaData!.toJson();
    }
    data['image'] = image;
    data['accessType'] = accessType;
    return data;
  }
}

class HomePageContentResponseDetailsDailyRoutine {
/*
{
  "title": "Daily Routine",
  "content": [
    {
      "title": "Sleep Tracker",
      "desc": "Monitor your sleep for better insights",
      "duration": "1 Min",
      "metaData": {
        "icon": "Play",
        "iconBGColor": "#FFFFFF",
        "iconColor": "#FFFFFF",
        "titleColor": "#FFFFFF",
        "descColor": "#FFFFFF"
      },
      "image": "https://stg-content.aayu.live/dailyroutine/sleep.png",
      "accessType": "sleep"
    }
  ]
} 
*/

  String? title;
  List<HomePageContentResponseDetailsDailyRoutineContent?>? content;

  HomePageContentResponseDetailsDailyRoutine({
    this.title,
    this.content,
  });
  HomePageContentResponseDetailsDailyRoutine.fromJson(
      Map<String, dynamic> json) {
    title = json['title']?.toString();
    if (json['content'] != null) {
      final v = json['content'];
      final arr0 = <HomePageContentResponseDetailsDailyRoutineContent>[];
      v.forEach((v) {
        arr0.add(HomePageContentResponseDetailsDailyRoutineContent.fromJson(v));
      });
      content = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    if (content != null) {
      final v = content;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['content'] = arr0;
    }
    return data;
  }
}

class HomePageContentResponseDetailsSequence {
/*
{
  "type": "Listings",
  "sequenceId": "1",
  "template": null
} 
*/

  String? type;
  String? sequenceId;
  String? template;

  HomePageContentResponseDetailsSequence({
    this.type,
    this.sequenceId,
    this.template,
  });
  HomePageContentResponseDetailsSequence.fromJson(Map<String, dynamic> json) {
    type = json['type']?.toString();
    sequenceId = json['sequenceId']?.toString();
    template = json['template']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['type'] = type;
    data['sequenceId'] = sequenceId;
    data['template'] = template;
    return data;
  }
}

class HomePageContentResponseDetails {
/*
{
  "sequence": [
    {
      "type": "Listings",
      "sequenceId": "1",
      "template": null
    }
  ],
  "listings": [
    {
      "categoryId": "e77abd60-b4af-11ec-ab2b-f7213fb54621",
      "categoryName": "Handpicked for you",
      "showMore": true,
      "bgColor": "#FFFFFF",
      "medaDataBgColor": "#F1F1F1",
      "content": [
        {
          "contentId": "dfd7da90-9f26-4d9f-be4a-9e2c9ebee411",
          "contentName": "Compassion Towards Yourself",
          "contentImage": "https://stg-content.aayu.live/Relationship/finalcontent/CompassionTowardsYourself/CompassionTowardsYourself_966x543.jpg",
          "contentType": "Audio",
          "contentPath": "https://stg-content.aayu.live/Relationship/finalcontent/CompassionTowardsYourself/CompassionTowardsYourself.mp3",
          "playBGImage": "https://stg-content.aayu.live/Relationship/finalcontent/CompassionTowardsYourself/CompassionTowardsYourself_1125x2436.jpg",
          "favourite": false,
          "artist": {
            "artistId": "623c63-79af00707-3b0782br0",
            "artistName": "Cara Pereira",
            "artistImage": "https://stg-content.aayu.live/Meditations/artistimages/images3x/CaraPereira.png"
          },
          "metaData": {
            "duration": "11 min",
            "rating": 4.4,
            "views": "5k",
            "multiSeries": false,
            "tags": [
              {
                "displayTagId": "1",
                "displayTag": "Breath And Energy Awareness"
              }
            ]
          }
        }
      ]
    }
  ],
  "affirmation": {
    "contentId": "81e167cf-7de1-4594-92e9-0d96d54d995e",
    "contentName": "Affirmation Logo",
    "contentImage": "https://stg-content.aayu.live/Affirmations/Image/affirmationlogotext.jpg",
    "contentType": "Image",
    "contentPath": "https://stg-content.aayu.live/Affirmations/Image/affirmationlogotext.jpg",
    "playBGImage": "https://stg-content.aayu.live/Affirmations/Image/affirmationlogotext.jpg",
    "favourite": false,
    "artist": {
      "artistId": "",
      "artistName": "",
      "artistImage": "https://stg-content.aayu.live"
    },
    "metaData": {
      "duration": " min",
      "rating": 4.4,
      "views": "5k",
      "multiSeries": false,
      "tags": [
        null
      ]
    }
  },
  "dailyRoutine": {
    "title": "Daily Routine",
    "content": [
      {
        "title": "Sleep Tracker",
        "desc": "Monitor your sleep for better insights",
        "duration": "1 Min",
        "metaData": {
          "icon": "Play",
          "iconBGColor": "#FFFFFF",
          "iconColor": "#FFFFFF",
          "titleColor": "#FFFFFF",
          "descColor": "#FFFFFF"
        },
        "image": "https://stg-content.aayu.live/dailyroutine/sleep.png",
        "accessType": "sleep"
      }
    ]
  }
} 
*/

  List<HomePageContentResponseDetailsSequence?>? sequence;
  List<ContentCategories?>? listings;
  Content? affirmation;
  HomePageContentResponseDetailsDailyRoutine? dailyRoutine;

  HomePageContentResponseDetails({
    this.sequence,
    this.listings,
    this.affirmation,
    this.dailyRoutine,
  });
  HomePageContentResponseDetails.fromJson(Map<String, dynamic> json) {
    if (json['sequence'] != null) {
      final v = json['sequence'];
      final arr0 = <HomePageContentResponseDetailsSequence>[];
      v.forEach((v) {
        arr0.add(HomePageContentResponseDetailsSequence.fromJson(v));
      });
      sequence = arr0;
    }
    if (json['listings'] != null) {
      final v = json['listings'];
      final arr0 = <ContentCategories>[];
      v.forEach((v) {
        arr0.add(ContentCategories.fromJson(v));
      });
      listings = arr0;
    }
    affirmation = (json['affirmation'] != null)
        ? Content.fromJson(json['affirmation'])
        : null;
    dailyRoutine = (json['dailyRoutine'] != null)
        ? HomePageContentResponseDetailsDailyRoutine.fromJson(
            json['dailyRoutine'])
        : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (sequence != null) {
      final v = sequence;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['sequence'] = arr0;
    }
    if (listings != null) {
      final v = listings;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['listings'] = arr0;
    }
    if (affirmation != null) {
      data['affirmation'] = affirmation!.toJson();
    }
    if (dailyRoutine != null) {
      data['dailyRoutine'] = dailyRoutine!.toJson();
    }
    return data;
  }
}

class HomePageContentResponse {
/*
{
  "details": {
    "sequence": [
      {
        "type": "Listings",
        "sequenceId": "1",
        "template": null
      }
    ],
    "listings": [
      {
        "categoryId": "e77abd60-b4af-11ec-ab2b-f7213fb54621",
        "categoryName": "Handpicked for you",
        "showMore": true,
        "bgColor": "#FFFFFF",
        "medaDataBgColor": "#F1F1F1",
        "content": [
          {
            "contentId": "dfd7da90-9f26-4d9f-be4a-9e2c9ebee411",
            "contentName": "Compassion Towards Yourself",
            "contentImage": "https://stg-content.aayu.live/Relationship/finalcontent/CompassionTowardsYourself/CompassionTowardsYourself_966x543.jpg",
            "contentType": "Audio",
            "contentPath": "https://stg-content.aayu.live/Relationship/finalcontent/CompassionTowardsYourself/CompassionTowardsYourself.mp3",
            "playBGImage": "https://stg-content.aayu.live/Relationship/finalcontent/CompassionTowardsYourself/CompassionTowardsYourself_1125x2436.jpg",
            "favourite": false,
            "artist": {
              "artistId": "623c63-79af00707-3b0782br0",
              "artistName": "Cara Pereira",
              "artistImage": "https://stg-content.aayu.live/Meditations/artistimages/images3x/CaraPereira.png"
            },
            "metaData": {
              "duration": "11 min",
              "rating": 4.4,
              "views": "5k",
              "multiSeries": false,
              "tags": [
                {
                  "displayTagId": "1",
                  "displayTag": "Breath And Energy Awareness"
                }
              ]
            }
          }
        ]
      }
    ],
    "affirmation": {
      "contentId": "81e167cf-7de1-4594-92e9-0d96d54d995e",
      "contentName": "Affirmation Logo",
      "contentImage": "https://stg-content.aayu.live/Affirmations/Image/affirmationlogotext.jpg",
      "contentType": "Image",
      "contentPath": "https://stg-content.aayu.live/Affirmations/Image/affirmationlogotext.jpg",
      "playBGImage": "https://stg-content.aayu.live/Affirmations/Image/affirmationlogotext.jpg",
      "favourite": false,
      "artist": {
        "artistId": "",
        "artistName": "",
        "artistImage": "https://stg-content.aayu.live"
      },
      "metaData": {
        "duration": " min",
        "rating": 4.4,
        "views": "5k",
        "multiSeries": false,
        "tags": [
          null
        ]
      }
    },
    "dailyRoutine": {
      "title": "Daily Routine",
      "content": [
        {
          "title": "Sleep Tracker",
          "desc": "Monitor your sleep for better insights",
          "duration": "1 Min",
          "metaData": {
            "icon": "Play",
            "iconBGColor": "#FFFFFF",
            "iconColor": "#FFFFFF",
            "titleColor": "#FFFFFF",
            "descColor": "#FFFFFF"
          },
          "image": "https://stg-content.aayu.live/dailyroutine/sleep.png",
          "accessType": "sleep"
        }
      ]
    }
  }
} 
*/

  HomePageContentResponseDetails? details;

  HomePageContentResponse({
    this.details,
  });
  HomePageContentResponse.fromJson(Map<String, dynamic> json) {
    details = (json['details'] != null)
        ? HomePageContentResponseDetails.fromJson(json['details'])
        : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (details != null) {
      data['details'] = details!.toJson();
    }
    return data;
  }
}
