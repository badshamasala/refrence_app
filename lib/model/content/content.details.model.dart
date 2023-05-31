import 'package:aayu/model/grow/grow.page.content.model.dart';

class ContentDetailsResponseEpisodes {
/*
{
  "contentId": "ede9c55a-b21a-40bc-88cd-32f0a3e3e94c",
  "contentName": "Affectionate Breathing - Self Love Meditation",
  "contentType": "",
  "contentImage": "https://resetcontent.s3.ap-south-1.amazonaws.com/Relationship/finalcontent/AffectionateBreathingSelfLoveMeditation/AffectionateBreathingSelfLoveMeditation_966x543.jpg",
  "contentDesc": "",
  "contentPath": "https://resetcontent.s3.ap-south-1.amazonaws.comhttps://resetcontent.s3.ap-south-1.amazonaws.com/Relationship/finalcontent/AffectionateBreathingSelfLoveMeditation/AffectionateBreathingSelfLoveMeditation.mp3",
  "playBGImage": "https://resetcontent.s3.ap-south-1.amazonaws.com/Relationship/finalcontent/AffectionateBreathingSelfLoveMeditation/AffectionateBreathingSelfLoveMeditation_1125x2436.jpg",
  "metaData": {
    "duration": "9",
    "rating": 4.4,
    "views": "5k",
    "language": "",
    "multiSeries": false,
    "tags": [
      {
        "displayTagId": "1",
        "displayTag": "Self -Observation"
      }
    ]
  },
  "enabled": false
} 
*/

  String? contentId;
  String? contentName;
  String? contentType;
  String? contentImage;
  String? contentDesc;
  String? contentPath;
  String? playBGImage;
  ContentMetaData? metaData;
  bool? enabled;

  ContentDetailsResponseEpisodes({
    this.contentId,
    this.contentName,
    this.contentType,
    this.contentImage,
    this.contentDesc,
    this.contentPath,
    this.playBGImage,
    this.metaData,
    this.enabled,
  });
  ContentDetailsResponseEpisodes.fromJson(Map<String, dynamic> json) {
    contentId = json['contentId']?.toString();
    contentName = json['contentName']?.toString();
    contentType = json['contentType']?.toString();
    contentImage = json['contentImage']?.toString();
    contentDesc = json['contentDesc']?.toString();
    contentPath = json['contentPath']?.toString();
    playBGImage = json['playBGImage']?.toString();
    metaData = (json['metaData'] != null)
        ? ContentMetaData.fromJson(json['metaData'])
        : null;
    enabled = json['enabled'];
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['contentId'] = contentId;
    data['contentName'] = contentName;
    data['contentType'] = contentType;
    data['contentImage'] = contentImage;
    data['contentDesc'] = contentDesc;
    data['contentPath'] = contentPath;
    data['playBGImage'] = playBGImage;
    if (metaData != null) {
      data['metaData'] = metaData!.toJson();
    }
    data['enabled'] = enabled;
    return data;
  }
}

class ContentDetailsResponse {
/*
{
  "content": {
    "contentId": "ede9c55a-b21a-40bc-88cd-32f0a3e3e94c",
    "contentName": "Affectionate Breathing - Self Love Meditation",
    "contentType": "",
    "contentImage": "https://resetcontent.s3.ap-south-1.amazonaws.com/Relationship/finalcontent/AffectionateBreathingSelfLoveMeditation/AffectionateBreathingSelfLoveMeditation_966x543.jpg",
    "contentDesc": "",
    "contentPath": "https://resetcontent.s3.ap-south-1.amazonaws.comhttps://resetcontent.s3.ap-south-1.amazonaws.com/Relationship/finalcontent/AffectionateBreathingSelfLoveMeditation/AffectionateBreathingSelfLoveMeditation.mp3",
    "playBGImage": "https://resetcontent.s3.ap-south-1.amazonaws.com/Relationship/finalcontent/AffectionateBreathingSelfLoveMeditation/AffectionateBreathingSelfLoveMeditation_1125x2436.jpg",
    "isFavourite": false,
    "artist": {
      "artistId": "623c63-79af00707-3b0782br0",
      "artistName": "Cara Pereira",
      "artistImage": "https://resetcontent.s3.ap-south-1.amazonaws.com/Meditations/artistimages/images3x/CaraPereira.png",
      "followers": "14.1 K",
      "isFollowed": false
    },
    "metaData": {
      "duration": "9",
      "rating": 4.4,
      "views": "5k",
      "language": "",
      "multiSeries": false,
      "tags": [
        {
          "displayTagId": "1",
          "displayTag": "Self -Observation"
        }
      ]
    }
  },
  "episodes": [
        {
            "contentId": "ede9c55a-b21a-40bc-88cd-32f0a3e3e94c",
            "contentName": "Affectionate Breathing - Self Love Meditation",
            "contentType": "",
            "contentImage": "https://resetcontent.s3.ap-south-1.amazonaws.com/Relationship/finalcontent/AffectionateBreathingSelfLoveMeditation/AffectionateBreathingSelfLoveMeditation_966x543.jpg",
            "contentDesc": "",
            "contentPath": "https://resetcontent.s3.ap-south-1.amazonaws.comhttps://resetcontent.s3.ap-south-1.amazonaws.com/Relationship/finalcontent/AffectionateBreathingSelfLoveMeditation/AffectionateBreathingSelfLoveMeditation.mp3",
            "playBGImage": "https://resetcontent.s3.ap-south-1.amazonaws.com/Relationship/finalcontent/AffectionateBreathingSelfLoveMeditation/AffectionateBreathingSelfLoveMeditation_1125x2436.jpg",
            "metaData": {
                "duration": "9",
                "rating": 4.4,
                "views": "5k",
                "language": "",
                "multiSeries": false,
                "tags": [
                    {
                        "displayTagId": "1",
                        "displayTag": "Self -Observation"
                    },
                    {
                        "displayTagId": "2",
                        "displayTag": " Health"
                    },
                    {
                        "displayTagId": "3",
                        "displayTag": " Breath and Energy Awareness"
                    },
                    {
                        "displayTagId": "4",
                        "displayTag": " Guided Meditation"
                    },
                    {
                        "displayTagId": "5",
                        "displayTag": " Breath Awareness"
                    },
                    {
                        "displayTagId": "6",
                        "displayTag": " Healing"
                    },
                    {
                        "displayTagId": "7",
                        "displayTag": " Stress"
                    },
                    {
                        "displayTagId": "8",
                        "displayTag": " Anxiety"
                    }
                ]
            },
            "enabled": false
        }
    ]
} 
*/

  Content? content;
  List<ContentDetailsResponseEpisodes?>? episodes;

  ContentDetailsResponse({
    this.content,
    this.episodes,
  });
  ContentDetailsResponse.fromJson(Map<String, dynamic> json) {
    content =
        (json['content'] != null) ? Content.fromJson(json['content']) : null;
    if (json['episodes'] != null) {
      final v = json['episodes'];
      final arr0 = <ContentDetailsResponseEpisodes>[];
      v.forEach((v) {
        arr0.add(ContentDetailsResponseEpisodes.fromJson(v));
      });
      episodes = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (content != null) {
      data['content'] = content!.toJson();
    }
    if (episodes != null) {
      final v = episodes;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['episodes'] = arr0;
    }
    return data;
  }
}
