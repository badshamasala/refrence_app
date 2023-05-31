class ModuleLiveStatus {
/*
{
  "isLive": true,
  "isUnderMaintenance": false,
  "message": ""
} 
*/

  bool? isLive;
  bool? isUnderMaintenance;
  String? message;

  ModuleLiveStatus({
    this.isLive,
    this.isUnderMaintenance,
    this.message,
  });
  ModuleLiveStatus.fromJson(Map<String, dynamic> json) {
    isLive = json['isLive'] ?? false;
    isUnderMaintenance = json['isUnderMaintenance'] ?? false;
    message = json['message']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isLive'] = isLive ?? false;
    data['isUnderMaintenance'] = isUnderMaintenance ?? false;
    data['message'] = message;
    return data;
  }
}