class PersonalisedCareSubscriptionModelWhatYouGetList {
/*
{
  "image": "Images.myRoutineDoctor",
  "text": "Certified doctor consultation session: 1 included"
} 
*/

  String? image;
  String? text;

  PersonalisedCareSubscriptionModelWhatYouGetList({
    this.image,
    this.text,
  });
  PersonalisedCareSubscriptionModelWhatYouGetList.fromJson(
      Map<String, dynamic> json) {
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

class PersonalisedCareSubscriptionModel {
/*
{
  "title": "Personalised Care",
  "subtitle": "See a positive difference in your health and well-being with a Personalised Care Program created just for you by our certified doctors, based on scientific research and evidence.",
  "whatYouGetList": [
    {
      "image": "Images.myRoutineDoctor",
      "text": "Certified doctor consultation session: 1 included"
    }
  ],
  "youAlsoGetList": [
    "Get free access to premium grow content"
  ]
} 
*/

  String? title;
  String? subtitle;
  List<PersonalisedCareSubscriptionModelWhatYouGetList?>? whatYouGetList;
  List<String?>? youAlsoGetList;

  PersonalisedCareSubscriptionModel({
    this.title,
    this.subtitle,
    this.whatYouGetList,
    this.youAlsoGetList,
  });
  PersonalisedCareSubscriptionModel.fromJson(Map<String, dynamic> json) {
    title = json['title']?.toString();
    subtitle = json['subtitle']?.toString();
    if (json['whatYouGetList'] != null) {
      final v = json['whatYouGetList'];
      final arr0 = <PersonalisedCareSubscriptionModelWhatYouGetList>[];
      v.forEach((v) {
        arr0.add(PersonalisedCareSubscriptionModelWhatYouGetList.fromJson(v));
      });
      whatYouGetList = arr0;
    }
    if (json['youAlsoGetList'] != null) {
      final v = json['youAlsoGetList'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      youAlsoGetList = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['subtitle'] = subtitle;
    if (whatYouGetList != null) {
      final v = whatYouGetList;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data['whatYouGetList'] = arr0;
    }
    if (youAlsoGetList != null) {
      final v = youAlsoGetList;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v);
      }
      data['youAlsoGetList'] = arr0;
    }
    return data;
  }
}
