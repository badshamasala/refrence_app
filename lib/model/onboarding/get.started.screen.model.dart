///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class GetStartedScreenModelScreens {
/*
{
  "heading": "Healing\nPrograms",
  "subTitle": "Lorem ipsum dolor sit amet, consectetur adipiscing elit ipsum dolor sit amet.",
  "image": "assets/images/home/lotus.png"
} 
*/

  String? heading;
  String? subTitle;
  String? image;

  GetStartedScreenModelScreens({
    this.heading,
    this.subTitle,
    this.image,
  });
  GetStartedScreenModelScreens.fromJson(Map<String, dynamic> json) {
    heading = json['heading']?.toString();
    subTitle = json['subTitle']?.toString();
    image = json['image']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['heading'] = heading;
    data['subTitle'] = subTitle;
    data['image'] = image;
    return data;
  }
}

class GetStartedScreenModel {
/*
{
  "screens": [
    {
      "heading": "Healing\nPrograms",
      "subTitle": "Lorem ipsum dolor sit amet, consectetur adipiscing elit ipsum dolor sit amet.",
      "image": "assets/images/home/lotus.png"
    }
  ]
} 
*/

  List<GetStartedScreenModelScreens?>? screens;

  GetStartedScreenModel({
    this.screens,
  });
  GetStartedScreenModel.fromJson(Map<String, dynamic> json) {
    if (json['screens'] != null) {
      final v = json['screens'];
      final arr0 = <GetStartedScreenModelScreens>[];
      v.forEach((v) {
        arr0.add(GetStartedScreenModelScreens.fromJson(v));
      });
      screens = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (screens != null) {
      final v = screens;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['screens'] = arr0;
    }
    return data;
  }
}