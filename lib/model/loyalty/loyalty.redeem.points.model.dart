///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class LoyaltyRedeemPointsModel {
/*
{
  "isRedeemed": true,
  "message": "REDEEM_SUCCESS",
  "vPoints": 26,
  "mPoints": 0
} 
*/

  bool? isRedeemed;
  String? message;
  int? vPoints;
  int? mPoints;

  LoyaltyRedeemPointsModel({
    this.isRedeemed,
    this.message,
    this.vPoints,
    this.mPoints,
  });
  LoyaltyRedeemPointsModel.fromJson(Map<String, dynamic> json) {
    isRedeemed = json['isRedeemed'];
    message = json['message']?.toString();
    vPoints = int.tryParse(json['vPoints']?.toString() ?? '');
    mPoints = int.tryParse(json['mPoints']?.toString() ?? '');
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isRedeemed'] = isRedeemed;
    data['message'] = message;
    data['vPoints'] = vPoints;
    data['mPoints'] = mPoints;
    return data;
  }
}
