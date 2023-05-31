///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class SubscriptionCarouselModelListModel {
/*
{
  "image": "https://stg-content.aayu.live/aayu/app/subscription/01_subs_icon.png",
  "text": "Access any one science backed, chronic disease healing, yoga therapy program."
} 
*/

  String? image;
  String? text;

  SubscriptionCarouselModelListModel({
    this.image,
    this.text,
  });
  SubscriptionCarouselModelListModel.fromJson(Map<String, dynamic> json) {
    image = json['image']?.toString();
    text = json['text']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['text'] = text;
    return data;
  }
}

class SubscriptionCarouselModelTitle {
/*
{
  "healing": "Activate your Aayu Subscription",
  "grow": "Activate your Aayu Subscription",
  "personalCare": "Activate your Personalised Care Program Subscription"
} 
*/

  String? healing;
  String? grow;
  String? personalCare;

  SubscriptionCarouselModelTitle({
    this.healing,
    this.grow,
    this.personalCare,
  });
  SubscriptionCarouselModelTitle.fromJson(Map<String, dynamic> json) {
    healing = json['healing']?.toString();
    grow = json['grow']?.toString();
    personalCare = json['personalCare']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['healing'] = healing;
    data['grow'] = grow;
    data['personalCare'] = personalCare;
    return data;
  }
}

class SubscriptionCarouselModel {
/*
{
  "title": {
    "healing": "Activate your Aayu Subscription",
    "grow": "Activate your Aayu Subscription",
    "personalCare": "Activate your Personalised Care Program Subscription"
  },
  "healing": [
    {
      "image": "https://stg-content.aayu.live/aayu/app/subscription/Access_any_Subscription_BG_1.json",
      "text": "Access any one science backed, chronic disease healing, yoga therapy program."
    }
  ],
  "grow": [
    {
      "image": "https://stg-content.aayu.live/aayu/app/subscription/Enjoy_thousands_Subscription_BG_4.json",
      "text": "Enjoy thousands of minutes of growth and mindfulness content uninterrupted."
    }
  ],
  "personalCare": [
    {
      "image": "https://stg-content.aayu.live/aayu/app/subscription/Enjoy_thousands_Subscription_BG_4.json",
      "text": "Heal better from all your chronic diseases with personalised care and a program created just for you by certified experts."
    }
  ]
} 
*/

  SubscriptionCarouselModelTitle? title;
  List<SubscriptionCarouselModelListModel?>? healing;
  List<SubscriptionCarouselModelListModel?>? grow;
  List<SubscriptionCarouselModelListModel?>? personalCare;

  SubscriptionCarouselModel({
    this.title,
    this.healing,
    this.grow,
    this.personalCare,
  });
  SubscriptionCarouselModel.fromJson(Map<String, dynamic> json) {
    title = (json['title'] != null)
        ? SubscriptionCarouselModelTitle.fromJson(json['title'])
        : null;
    if (json['healing'] != null) {
      final v = json['healing'];
      final arr0 = <SubscriptionCarouselModelListModel>[];
      v.forEach((v) {
        arr0.add(SubscriptionCarouselModelListModel.fromJson(v));
      });
      healing = arr0;
    }
    if (json['grow'] != null) {
      final v = json['grow'];
      final arr0 = <SubscriptionCarouselModelListModel>[];
      v.forEach((v) {
        arr0.add(SubscriptionCarouselModelListModel.fromJson(v));
      });
      grow = arr0;
    }
    if (json['personalCare'] != null) {
      final v = json['personalCare'];
      final arr0 = <SubscriptionCarouselModelListModel>[];
      v.forEach((v) {
        arr0.add(SubscriptionCarouselModelListModel.fromJson(v));
      });
      personalCare = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (title != null) {
      data['title'] = title!.toJson();
    }
    if (healing != null) {
      final v = healing;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data['healing'] = arr0;
    }
    if (grow != null) {
      final v = grow;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data['grow'] = arr0;
    }
    if (personalCare != null) {
      final v = personalCare;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data['personalCare'] = arr0;
    }
    return data;
  }
}