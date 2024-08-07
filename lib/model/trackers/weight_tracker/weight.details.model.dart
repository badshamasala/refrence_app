///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class WeightDetailsModel {
/*
{
  "defaultUnit": "LBS",
  "weight": 0.3
} 
*/

  String? defaultUnit;
  double? weight;

  WeightDetailsModel({
    this.defaultUnit,
    this.weight,
  });
  WeightDetailsModel.fromJson(Map<String, dynamic> json) {
    defaultUnit = json['defaultUnit']?.toString();
    weight = double.tryParse(json['weight']?.toString() ?? '');
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['defaultUnit'] = defaultUnit;
    data['weight'] = weight;
    return data;
  }
}
