///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class HealingQuizResponseTodaysQuizOptions {
/*
{
  "option": "Type 1-100",
  "selected": false,
  "correctAnswer": false
} 
*/

  String? option;
  bool? selected;
  bool? correctAnswer;

  HealingQuizResponseTodaysQuizOptions({
    this.option,
    this.selected,
    this.correctAnswer,
  });
  HealingQuizResponseTodaysQuizOptions.fromJson(Map<String, dynamic> json) {
    option = json['option']?.toString();
    selected = json['selected'];
    correctAnswer = json['correctAnswer'];
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['option'] = option;
    data['selected'] = selected;
    data['correctAnswer'] = correctAnswer;
    return data;
  }
}

class HealingQuizResponseTodaysQuiz {
/*
{
  "quizId":"",
  "quiz": "Weight gain is common feature of which Diabetes",
  "details": null,
  "answerSubmitted": false,
  "options": [
    {
      "option": "Type 1-100",
      "selected": false,
      "correctAnswer": false
    }
  ]
} 
*/

  String? quizId;
  String? quiz;
  String? details;
  bool? answerSubmitted;
  List<HealingQuizResponseTodaysQuizOptions?>? options;

  HealingQuizResponseTodaysQuiz({
    this.quiz,
    this.details,
    this.answerSubmitted,
    this.options,
  });
  HealingQuizResponseTodaysQuiz.fromJson(Map<String, dynamic> json) {
    quizId = json['quizId']?.toString();
    quiz = json['quiz']?.toString();
    details = json['details']?.toString();
    answerSubmitted = json['answerSubmitted'];
  if (json['options'] != null) {
  final v = json['options'];
  final arr0 = <HealingQuizResponseTodaysQuizOptions>[];
  v.forEach((v) {
  arr0.add(HealingQuizResponseTodaysQuizOptions.fromJson(v));
  });
    options = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['quizId'] = quizId;
    data['quiz'] = quiz;
    data['details'] = details;
    data['answerSubmitted'] = answerSubmitted;
    if (options != null) {
      final v = options;
      final arr0 = [];
  v!.forEach((v) {
  arr0.add(v!.toJson());
  });
      data['options'] = arr0;
    }
    return data;
  }
}

class HealingQuizResponse {
/*
{
  "todaysQuiz": {
    "quiz":"",
    "quiz": "Weight gain is common feature of which Diabetes",
    "details": null,
    "answerSubmitted": false,
    "options": [
      {
        "option": "Type 1-100",
        "selected": false,
        "correctAnswer": false
      }
    ]
  }
} 
*/

  HealingQuizResponseTodaysQuiz? todaysQuiz;

  HealingQuizResponse({
    this.todaysQuiz,
  });
  HealingQuizResponse.fromJson(Map<String, dynamic> json) {
    todaysQuiz = (json['todaysQuiz'] != null) ? HealingQuizResponseTodaysQuiz.fromJson(json['todaysQuiz']) : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (todaysQuiz != null) {
      data['todaysQuiz'] = todaysQuiz!.toJson();
    }
    return data;
  }
}
