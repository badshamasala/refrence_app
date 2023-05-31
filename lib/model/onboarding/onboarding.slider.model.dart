class OnBoardingModel {
  List<OnBoardingList>? onBoardingList;

  OnBoardingModel({this.onBoardingList});

  OnBoardingModel.fromJson(Map<String, dynamic> json) {
    if (json['onBoardingList'] != null) {
      onBoardingList = <OnBoardingList>[];
      json['onBoardingList'].forEach((v) {
        onBoardingList!.add(new OnBoardingList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.onBoardingList != null) {
      data['onBoardingList'] =
          this.onBoardingList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OnBoardingList {
  String? heading;
  String? subTitle;
  String? image;

  OnBoardingList({this.heading, this.subTitle, this.image});

  OnBoardingList.fromJson(Map<String, dynamic> json) {
    heading = json['heading'];
    subTitle = json['subTitle'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['heading'] = this.heading;
    data['subTitle'] = this.subTitle;
    data['image'] = this.image;
    return data;
  }
}
