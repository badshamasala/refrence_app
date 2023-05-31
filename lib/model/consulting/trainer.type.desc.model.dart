///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class TrainerTypeDescModelTrainerTypeList {
/*
{
  "title": "Personal Yoga Trainer",
  "trainerType": "Therapist",
  "image": "",
  "desc": [
    "Personalised yoga activity"
  ]
} 
*/

  String? title;
  String? trainerType;
  String? image;
  List<String?>? desc;
  String? cta;

  TrainerTypeDescModelTrainerTypeList({
    this.title,
    this.trainerType,
    this.image,
    this.desc,
    this.cta,
  });
  TrainerTypeDescModelTrainerTypeList.fromJson(Map<String, dynamic> json) {
    title = json['title']?.toString();
    trainerType = json['trainerType']?.toString();
    image = json['image']?.toString();
    if (json['desc'] != null) {
      final v = json['desc'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      desc = arr0;
    }
    cta = json['cta']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['trainerType'] = trainerType;
    data['image'] = image;
    if (desc != null) {
      final v = desc;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v);
      });
      data['desc'] = arr0;
    }
    data['cta'] = cta;
    return data;
  }
}

class TrainerTypeDescModel {
/*
{
  "trainerTypeList": [
    {
      "title": "Personal Yoga Trainer",
      "trainerType": "Therapist",
      "image": "",
      "desc": [
        "Personalised yoga activity"
      ]
    }
  ]
} 
*/

  List<TrainerTypeDescModelTrainerTypeList?>? trainerTypeList;

  TrainerTypeDescModel({
    this.trainerTypeList,
  });
  TrainerTypeDescModel.fromJson(Map<String, dynamic> json) {
    if (json['trainerTypeList'] != null) {
      final v = json['trainerTypeList'];
      final arr0 = <TrainerTypeDescModelTrainerTypeList>[];
      v.forEach((v) {
        arr0.add(TrainerTypeDescModelTrainerTypeList.fromJson(v));
      });
      trainerTypeList = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (trainerTypeList != null) {
      final v = trainerTypeList;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['trainerTypeList'] = arr0;
    }
    return data;
  }
}
