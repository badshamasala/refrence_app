///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class  NutritionInitialAssessmentStatusModelAssessmentStatus {
/*
{
  "isStarted": true,
  "isCompleted": false
} 
*/

  bool? isStarted;
  bool? isCompleted;

   NutritionInitialAssessmentStatusModelAssessmentStatus({
    this.isStarted,
    this.isCompleted,
  });
   NutritionInitialAssessmentStatusModelAssessmentStatus.fromJson(Map<String, dynamic> json) {
    isStarted = json['isStarted'];
    isCompleted = json['isCompleted'];
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isStarted'] = isStarted;
    data['isCompleted'] = isCompleted;
    return data;
  }
}

class  NutritionInitialAssessmentStatusModel {
/*
{
  "assessmentStatus": {
    "isStarted": true,
    "isCompleted": false
  }
} 
*/

   NutritionInitialAssessmentStatusModelAssessmentStatus? assessmentStatus;

   NutritionInitialAssessmentStatusModel({
    this.assessmentStatus,
  });
   NutritionInitialAssessmentStatusModel.fromJson(Map<String, dynamic> json) {
    assessmentStatus = (json['assessmentStatus'] != null) ?  NutritionInitialAssessmentStatusModelAssessmentStatus.fromJson(json['assessmentStatus']) : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (assessmentStatus != null) {
      data['assessmentStatus'] = assessmentStatus!.toJson();
    }
    return data;
  }
}
