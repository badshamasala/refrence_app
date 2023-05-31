class InitialStatusModel {
  Data? data;

  InitialStatusModel({this.data});

  InitialStatusModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  bool? isStarted;
  bool? isCompleted;
  String? percentage;

  Data({this.isStarted, this.isCompleted, this.percentage});

  Data.fromJson(Map<String, dynamic> json) {
    isStarted = json['isStarted'];
    isCompleted = json['isCompleted'];
    percentage = json['percentage'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isStarted'] = isStarted;
    data['isCompleted'] = isCompleted;
    data['percentage'] = percentage;
    return data;
  }
}
