///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class WeeklyHealthCardModelHealthCardListWeeksPercentage {
/*
{
  "categoryId": "2a3df1d0-c9e1-11ec-9700-bb7ddedd83e9",
  "percentage": 0,
  "percentageColor": "#A5ECD1",
  "startedAt": 0,
  "categoryName": "Nutrition"
} 
*/

  String? categoryId;
  int? percentage;
  String? percentageColor;
  int? startedAt;
  String? categoryName;

  WeeklyHealthCardModelHealthCardListWeeksPercentage({
    this.categoryId,
    this.percentage,
    this.percentageColor,
    this.startedAt,
    this.categoryName,
  });
  WeeklyHealthCardModelHealthCardListWeeksPercentage.fromJson(
      Map<String, dynamic> json) {
    categoryId = json['categoryId']?.toString();
    percentage = json['percentage']?.toInt();
    percentageColor = json['percentageColor']?.toString();
    startedAt = json['startedAt']?.toInt();
    categoryName = json['categoryName']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['categoryId'] = categoryId;
    data['percentage'] = percentage;
    data['percentageColor'] = percentageColor;
    data['startedAt'] = startedAt;
    data['categoryName'] = categoryName;
    return data;
  }
}

class WeeklyHealthCardModelHealthCardListWeeks {
/*
{
  "week": "1",
  "totalPercentage": 0,
  "progressPercent": 0,
  "percentage": [
    {
      "categoryId": "2a3df1d0-c9e1-11ec-9700-bb7ddedd83e9",
      "percentage": 0,
      "percentageColor": "#A5ECD1",
      "startedAt": 0,
      "categoryName": "Nutrition"
    }
  ],
  "title": "Brilliant Effort!",
  "desc": "Your Aayu Score shows an improvement. Consistency is the key,so keep at it!"
} 
*/

  String? week;
  int? totalPercentage;
  int? progressPercent;
  String? startDate;
  String? endDate;
  List<WeeklyHealthCardModelHealthCardListWeeksPercentage?>? percentage;
  String? title;
  String? desc;

  WeeklyHealthCardModelHealthCardListWeeks({
    this.week,
    this.totalPercentage,
    this.progressPercent,
    this.percentage,
    this.startDate,
    this.endDate,
    this.title,
    this.desc,
  });
  WeeklyHealthCardModelHealthCardListWeeks.fromJson(Map<String, dynamic> json) {
    week = json['week']?.toString();
    totalPercentage = json['totalPercentage']?.toInt();
    progressPercent = json['progressPercent']?.toInt();
    if (json['percentage'] != null) {
      final v = json['percentage'];
      final arr0 = <WeeklyHealthCardModelHealthCardListWeeksPercentage>[];
      v.forEach((v) {
        arr0.add(
            WeeklyHealthCardModelHealthCardListWeeksPercentage.fromJson(v));
      });
      percentage = arr0;
    }
    startDate = json['startDate']?.toString();
    endDate = json['endDate']?.toString();
    title = json['title']?.toString();
    desc = json['desc']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['week'] = week;
    data['totalPercentage'] = totalPercentage;
    data['progressPercent'] = progressPercent;
    if (percentage != null) {
      final v = percentage;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data['percentage'] = arr0;
    }
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['title'] = title;
    data['desc'] = desc;
    return data;
  }
}

class WeeklyHealthCardModelHealthCardList {
/*
{
  "weeks": [
    {
      "week": "1",
      "totalPercentage": 0,
      "progressPercent": 0,
      "startDate":"yyyy-mm-dd",
      "endDate":"yyyy-mm-dd",  
      "percentage": [
        {
          "categoryId": "2a3df1d0-c9e1-11ec-9700-bb7ddedd83e9",
          "percentage": 0,
          "percentageColor": "#A5ECD1",
          "startedAt": 0,
          "categoryName": "Nutrition"
        }
      ],
      "title": "Brilliant Effort!",
      "desc": "Your Aayu Score shows an improvement. Consistency is the key,so keep at it!"
    }
  ]
} 
*/

  List<WeeklyHealthCardModelHealthCardListWeeks?>? weeks;

  WeeklyHealthCardModelHealthCardList({
    this.weeks,
  });
  WeeklyHealthCardModelHealthCardList.fromJson(Map<String, dynamic> json) {
    if (json['weeks'] != null) {
      final v = json['weeks'];
      final arr0 = <WeeklyHealthCardModelHealthCardListWeeks>[];
      v.forEach((v) {
        arr0.add(WeeklyHealthCardModelHealthCardListWeeks.fromJson(v));
      });
      weeks = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (weeks != null) {
      final v = weeks;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data['weeks'] = arr0;
    }
    return data;
  }
}

class WeeklyHealthCardModel {
/*
{
  "healthCardList": {
    "weeks": [
      {
        "week": "1",
        "totalPercentage": 0,
        "progressPercent": 0,
        "startDate":"yyyy-mm-dd",
        "endDate":"yyyy-mm-dd",  
        "percentage": [
          {
            "categoryId": "2a3df1d0-c9e1-11ec-9700-bb7ddedd83e9",
            "percentage": 0,
            "percentageColor": "#A5ECD1",
            "startedAt": 0,
            "categoryName": "Nutrition"
          }
        ],
        "title": "Brilliant Effort!",
        "desc": "Your Aayu Score shows an improvement. Consistency is the key,so keep at it!"
      }
    ]
  }
} 
*/

  WeeklyHealthCardModelHealthCardList? healthCardList;

  WeeklyHealthCardModel({
    this.healthCardList,
  });
  WeeklyHealthCardModel.fromJson(Map<String, dynamic> json) {
    healthCardList = (json['healthCardList'] != null)
        ? WeeklyHealthCardModelHealthCardList.fromJson(json['healthCardList'])
        : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (healthCardList != null) {
      data['healthCardList'] = healthCardList!.toJson();
    }
    return data;
  }
}