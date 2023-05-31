///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class DiseaseDetailsResponseDetailsTabsContent {
/*
{
  "icon": "https://resetcontent.s3.ap-south-1.amazonaws.com/healing/group55.png",
  "text": "Enhances heart function"
} 
*/

  String? icon;
  String? text;

  DiseaseDetailsResponseDetailsTabsContent({
    this.icon,
    this.text,
  });
  DiseaseDetailsResponseDetailsTabsContent.fromJson(Map<String, dynamic> json) {
    icon = json['icon']?.toString();
    text = json['text']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['icon'] = icon;
    data['text'] = text;
    return data;
  }
}

class DiseaseDetailsResponseDetailsTabs {
/*
{
  "tabName": "Benefits",
  "content": [
    {
      "icon": "https://resetcontent.s3.ap-south-1.amazonaws.com/healing/group55.png",
      "text": "Enhances heart function"
    }
  ]
} 
*/

  String? tabName;
  List<DiseaseDetailsResponseDetailsTabsContent?>? content;

  DiseaseDetailsResponseDetailsTabs({
    this.tabName,
    this.content,
  });
  DiseaseDetailsResponseDetailsTabs.fromJson(Map<String, dynamic> json) {
    tabName = json['tabName']?.toString();
    if (json['content'] != null) {
      final v = json['content'];
      final arr0 = <DiseaseDetailsResponseDetailsTabsContent>[];
      v.forEach((v) {
        arr0.add(DiseaseDetailsResponseDetailsTabsContent.fromJson(v));
      });
      content = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['tabName'] = tabName;
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

class DiseaseDetailsResponseDetailsSilverAppBarImage {
/*
{
  "imageUrl": "https://resetcontent.s3.ap-south-1.amazonaws.com/healing/heartdisease.png",
  "height": 56.2,
  "width": 36.2
} 
*/

  String? imageUrl;
  double? height;
  double? width;

  DiseaseDetailsResponseDetailsSilverAppBarImage({
    this.imageUrl,
    this.height,
    this.width,
  });
  DiseaseDetailsResponseDetailsSilverAppBarImage.fromJson(
      Map<String, dynamic> json) {
    imageUrl = json['imageUrl']?.toString();
    height = json['height']?.toDouble();
    width = json['width']?.toDouble();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['imageUrl'] = imageUrl;
    data['height'] = height;
    data['width'] = width;
    return data;
  }
}

class DiseaseDetailsResponseDetailsSilverAppBar {
/*
{
  "title": "Heart Disease Care",
  "textColor": "#A6D7CA",
  "backgroundImage": "https://resetcontent.s3.ap-south-1.amazonaws.com/healing/HeartDisease_603x403.jpg",
  "image": {
    "imageUrl": "https://resetcontent.s3.ap-south-1.amazonaws.com/healing/heartdisease.png",
    "height": 56.2,
    "width": 36.2
  }
} 
*/

  String? title;
  String? textColor;
  String? backgroundImage;
  DiseaseDetailsResponseDetailsSilverAppBarImage? image;

  DiseaseDetailsResponseDetailsSilverAppBar({
    this.title,
    this.textColor,
    this.backgroundImage,
    this.image,
  });
  DiseaseDetailsResponseDetailsSilverAppBar.fromJson(
      Map<String, dynamic> json) {
    title = json['title']?.toString();
    textColor = json['textColor']?.toString();
    backgroundImage = json['backgroundImage']?.toString();
    image = (json['image'] != null)
        ? DiseaseDetailsResponseDetailsSilverAppBarImage.fromJson(json['image'])
        : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['textColor'] = textColor;
    data['backgroundImage'] = backgroundImage;
    if (image != null) {
      data['image'] = image!.toJson();
    }
    return data;
  }
}

class DiseaseDetailsResponseDetailsDeepLinkDetails {
/*
{
  "deepLink": "https://aayu.sng.link/Ah5m0/x0st/jj89",
  "shareMessage": "Heal from heart disease with evidence based yogatherapy"
} 
*/

  String? deepLink;
  String? shareMessage;

  DiseaseDetailsResponseDetailsDeepLinkDetails({
    this.deepLink,
    this.shareMessage,
  });
  DiseaseDetailsResponseDetailsDeepLinkDetails.fromJson(
      Map<String, dynamic> json) {
    deepLink = json['deepLink']?.toString();
    shareMessage = json['shareMessage']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['deepLink'] = deepLink;
    data['shareMessage'] = shareMessage;
    return data;
  }
}

class DiseaseDetailsResponseDetails {
/*
{
  "diseaseId": "1",
  "disease": "Heart Disease",
  "knowMoreLink": "https//:",
  "description": "Hey",
  "overview": "hey",
  "deepLinkDetails": {
    "deepLink": "https://aayu.sng.link/Ah5m0/x0st/jj89",
    "shareMessage": "Heal from heart disease with evidence based yogatherapy"
  },
  "silverAppBar": {
    "title": "Heart Disease Care",
    "textColor": "#A6D7CA",
    "backgroundImage": "https://resetcontent.s3.ap-south-1.amazonaws.com/healing/HeartDisease_603x403.jpg",
    "image": {
      "imageUrl": "https://resetcontent.s3.ap-south-1.amazonaws.com/healing/heartdisease.png",
      "height": 56.2,
      "width": 36.2
    }
  },
  "tabs": [
    {
      "tabName": "Benefits",
      "content": [
        {
          "icon": "https://resetcontent.s3.ap-south-1.amazonaws.com/healing/group55.png",
          "text": "Enhances heart function"
        }
      ]
    }
  ]
} 
*/

  String? diseaseId;
  String? disease;
  String? knowMoreLink;
  String? description;
  String? overview;
  DiseaseDetailsResponseDetailsDeepLinkDetails? deepLinkDetails;
  DiseaseDetailsResponseDetailsSilverAppBar? silverAppBar;
  List<DiseaseDetailsResponseDetailsTabs?>? tabs;

  DiseaseDetailsResponseDetails({
    this.diseaseId,
    this.disease,
    this.knowMoreLink,
    this.description,
    this.overview,
    this.deepLinkDetails,
    this.silverAppBar,
    this.tabs,
  });
  DiseaseDetailsResponseDetails.fromJson(Map<String, dynamic> json) {
    diseaseId = json['diseaseId']?.toString();
    disease = json['disease']?.toString();
    knowMoreLink = json['knowMoreLink']?.toString();
    description = json['description']?.toString();
    overview = json['overview']?.toString();
    deepLinkDetails = (json['deepLinkDetails'] != null)
        ? DiseaseDetailsResponseDetailsDeepLinkDetails.fromJson(
            json['deepLinkDetails'])
        : null;
    silverAppBar = (json['silverAppBar'] != null)
        ? DiseaseDetailsResponseDetailsSilverAppBar.fromJson(
            json['silverAppBar'])
        : null;
    if (json['tabs'] != null) {
      final v = json['tabs'];
      final arr0 = <DiseaseDetailsResponseDetailsTabs>[];
      v.forEach((v) {
        arr0.add(DiseaseDetailsResponseDetailsTabs.fromJson(v));
      });
      tabs = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['diseaseId'] = diseaseId;
    data['disease'] = disease;
    data['knowMoreLink'] = knowMoreLink;
    data['description'] = description;
    data['overview'] = overview;
    if (deepLinkDetails != null) {
      data['deepLinkDetails'] = deepLinkDetails!.toJson();
    }
    if (silverAppBar != null) {
      data['silverAppBar'] = silverAppBar!.toJson();
    }
    if (tabs != null) {
      final v = tabs;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data['tabs'] = arr0;
    }
    return data;
  }
}

class DiseaseDetailsResponse {
/*
{
  "details": {
    "diseaseId": "1",
    "disease": "Heart Disease",
    "knowMoreLink": "https//:",
    "description": "Hey",
    "overview": "hey",
    "deepLinkDetails": {
      "deepLink": "https://aayu.sng.link/Ah5m0/x0st/jj89",
      "shareMessage": "Heal from heart disease with evidence based yogatherapy"
    },
    "silverAppBar": {
      "title": "Heart Disease Care",
      "textColor": "#A6D7CA",
      "backgroundImage": "https://resetcontent.s3.ap-south-1.amazonaws.com/healing/HeartDisease_603x403.jpg",
      "image": {
        "imageUrl": "https://resetcontent.s3.ap-south-1.amazonaws.com/healing/heartdisease.png",
        "height": 56.2,
        "width": 36.2
      }
    },
    "tabs": [
      {
        "tabName": "Benefits",
        "content": [
          {
            "icon": "https://resetcontent.s3.ap-south-1.amazonaws.com/healing/group55.png",
            "text": "Enhances heart function"
          }
        ]
      }
    ]
  }
} 
*/

  DiseaseDetailsResponseDetails? details;

  DiseaseDetailsResponse({
    this.details,
  });
  DiseaseDetailsResponse.fromJson(Map<String, dynamic> json) {
    details = (json['details'] != null)
        ? DiseaseDetailsResponseDetails.fromJson(json['details'])
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
