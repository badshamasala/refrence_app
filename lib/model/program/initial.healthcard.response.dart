///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class InitialHealthCardResponseHealthcardPercentage {
/*
{
  "title": "Anxiety Disorder Management",
  "percentage": 52,
  "percentageColor": "#A5ECD1"
} 
*/

  String? title;
  int? percentage;
  String? categoryId;
  bool? isCompleted;
  int? answerCount;
  int? questionCount;
  String? percentageColor;

  InitialHealthCardResponseHealthcardPercentage({
    this.title,
    this.percentage,
    this.percentageColor,
  });
  InitialHealthCardResponseHealthcardPercentage.fromJson(
      Map<String, dynamic> json) {
    title = json['title']?.toString();
    percentage = json['percentage']?.toInt();
    percentageColor = json['percentageColor']?.toString();
    isCompleted = json['isCompleted'] ?? false;
    questionCount = json['questionCount']?.toInt();
    questionCount = json['questionCount']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['percentage'] = percentage;
    data['percentageColor'] = percentageColor;

    data['isCompleted'] = isCompleted ?? false;
    data['answerCount'] = answerCount;
    data['questionCount'] = questionCount;
    return data;
  }
}

class InitialHealthCardResponseHealthcard {
/*
{
  "title": "Your Current HeaLth Score",
  "description": "Your current health score based on the assesment questions. Overall current health score based on the assesment questions.",
  "totalPercentage": 48,
  "percentage": [
    {
      "title": "Anxiety Disorder Management",
      "percentage": 52,
      "percentageColor": "#A5ECD1"
    }
  ]
} 
*/

  String? title;
  String? description;
  int? totalPercentage;
  List<InitialHealthCardResponseHealthcardPercentage?>? percentage;

  InitialHealthCardResponseHealthcard({
    this.title,
    this.description,
    this.totalPercentage,
    this.percentage,
  });
  InitialHealthCardResponseHealthcard.fromJson(Map<String, dynamic> json) {
    title = json['title']?.toString();
    description = json['description']?.toString();
    totalPercentage = json['totalPercentage']?.toInt();
    if (json['percentage'] != null) {
      final v = json['percentage'];
      final arr0 = <InitialHealthCardResponseHealthcardPercentage>[];
      v.forEach((v) {
        arr0.add(InitialHealthCardResponseHealthcardPercentage.fromJson(v));
      });
      percentage = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['totalPercentage'] = totalPercentage;
    if (percentage != null) {
      final v = percentage;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['percentage'] = arr0;
    }
    return data;
  }
}

class InitialHealthCardResponse {
/*
{
  "healthcard": {
    "title": "Your Current HeaLth Score",
    "description": "Your current health score based on the assesment questions. Overall current health score based on the assesment questions.",
    "totalPercentage": 48,
    "percentage": [
      {
        "title": "Anxiety Disorder Management",
        "percentage": 52,
        "percentageColor": "#A5ECD1"
      }
    ]
  }
} 
*/

  InitialHealthCardResponseHealthcard? healthcard;

  InitialHealthCardResponse({
    this.healthcard,
  });
  InitialHealthCardResponse.fromJson(Map<String, dynamic> json) {
    healthcard = (json['healthcard'] != null)
        ? InitialHealthCardResponseHealthcard.fromJson(json['healthcard'])
        : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (healthcard != null) {
      data['healthcard'] = healthcard!.toJson();
    }
    return data;
  }
}
