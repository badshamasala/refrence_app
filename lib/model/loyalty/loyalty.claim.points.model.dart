///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class LoyaltyCliamPointsModel {
/*
{
  "userPointId": "b5f3d560-d9d9-11ed-970c-5789ce673f90",
  "vPoints": 36,
  "mPoints": 0
} 
*/

  String? userPointId;
  int? vPoints;
  int? mPoints;

  LoyaltyCliamPointsModel({
    this.userPointId,
    this.vPoints,
    this.mPoints,
  });
  LoyaltyCliamPointsModel.fromJson(Map<String, dynamic> json) {
    userPointId = json['userPointId']?.toString();
    vPoints = int.tryParse(json['vPoints']?.toString() ?? '');
    mPoints = int.tryParse(json['mPoints']?.toString() ?? '');
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userPointId'] = userPointId;
    data['vPoints'] = vPoints;
    data['mPoints'] = mPoints;
    return data;
  }
}