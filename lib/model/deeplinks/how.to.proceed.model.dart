class HowToProceedModel {
  List<Data>? data;

  HowToProceedModel({this.data});

  HowToProceedModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data?.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? srNo;
  String? image;
  String? title;
  String? description;

  Data({this.srNo, this.image, this.title, this.description});

  Data.fromJson(Map<String, dynamic> json) {
    srNo = json['srNo'];
    image = json['image'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['srNo'] = this.srNo;
    data['image'] = this.image;
    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }
}
