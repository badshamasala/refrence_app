///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class UserNutritionDetailsModelSelectedPackageAddOns {
/*
{
  "doctorSessions": 0,
  "therapistSessions": 0,
  "aayuSubscription": ""
} 
*/

  int? doctorSessions;
  int? therapistSessions;
  String? aayuSubscription;

  UserNutritionDetailsModelSelectedPackageAddOns({
    this.doctorSessions,
    this.therapistSessions,
    this.aayuSubscription,
  });
  UserNutritionDetailsModelSelectedPackageAddOns.fromJson(
      Map<String, dynamic> json) {
    doctorSessions = json['doctorSessions']?.toInt();
    therapistSessions = json['therapistSessions']?.toInt();
    aayuSubscription = json['aayuSubscription']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['doctorSessions'] = doctorSessions;
    data['therapistSessions'] = therapistSessions;
    data['aayuSubscription'] = aayuSubscription;
    return data;
  }
}

class UserNutritionDetailsModelSelectedPackage {
/*
{
  "addOns": {
    "doctorSessions": 0,
    "therapistSessions": 0,
    "aayuSubscription": ""
  },
  "dietPlans": 2,
  "displayText": "4 Weeks",
  "duration": "4 Weeks",
  "durationInDays": 28,
  "packageId": "e95899c0-befb-11ed-a9a9-b9bd3cb9374a",
  "purchaseType": "FIRST TIME",
  "sessions": 2,
  "whatYouGet": [
    "2 Consultations"
  ],
  "packageType": "BASIC",
  "paymentOrderId": "123456",
  "startDate": 1678440376000,
  "endDate": 1680859576000
} 
*/

  UserNutritionDetailsModelSelectedPackageAddOns? addOns;
  int? dietPlans;
  String? displayText;
  String? duration;
  int? durationInDays;
  String? packageId;
  String? purchaseType;
  int? sessions;
  List<String?>? whatYouGet;
  String? packageType;
  String? paymentOrderId;
  int? startDate;
  int? endDate;

  UserNutritionDetailsModelSelectedPackage({
    this.addOns,
    this.dietPlans,
    this.displayText,
    this.duration,
    this.durationInDays,
    this.packageId,
    this.purchaseType,
    this.sessions,
    this.whatYouGet,
    this.packageType,
    this.paymentOrderId,
    this.startDate,
    this.endDate,
  });
  UserNutritionDetailsModelSelectedPackage.fromJson(Map<String, dynamic> json) {
    addOns = (json['addOns'] != null)
        ? UserNutritionDetailsModelSelectedPackageAddOns.fromJson(
            json['addOns'])
        : null;
    dietPlans = json['dietPlans']?.toInt();
    displayText = json['displayText']?.toString();
    duration = json['duration']?.toString();
    durationInDays = json['durationInDays']?.toInt();
    packageId = json['packageId']?.toString();
    purchaseType = json['purchaseType']?.toString();
    sessions = json['sessions']?.toInt();
    if (json['whatYouGet'] != null) {
      final v = json['whatYouGet'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      whatYouGet = arr0;
    }
    packageType = json['packageType']?.toString();
    paymentOrderId = json['paymentOrderId']?.toString();
    startDate = json['startDate']?.toInt();
    endDate = json['endDate']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (addOns != null) {
      data['addOns'] = addOns!.toJson();
    }
    data['dietPlans'] = dietPlans;
    data['displayText'] = displayText;
    data['duration'] = duration;
    data['durationInDays'] = durationInDays;
    data['packageId'] = packageId;
    data['purchaseType'] = purchaseType;
    data['sessions'] = sessions;
    if (whatYouGet != null) {
      final v = whatYouGet;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v);
      });
      data['whatYouGet'] = arr0;
    }
    data['packageType'] = packageType;
    data['paymentOrderId'] = paymentOrderId;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    return data;
  }
}

class UserNutritionDetailsModelCurrentTrainer {
/*
{
  "coachId": "36362500-f846-11ec-b571-6d35ec14eac1",
  "coachName": "Dr. test trainer",
  "gender": "Male",
  "profilePhoto": ""
} 
*/

  String? coachId;
  String? coachName;
  String? gender;
  String? profilePhoto;

  UserNutritionDetailsModelCurrentTrainer({
    this.coachId,
    this.coachName,
    this.gender,
    this.profilePhoto,
  });
  UserNutritionDetailsModelCurrentTrainer.fromJson(Map<String, dynamic> json) {
    coachId = json['coachId']?.toString();
    coachName = json['coachName']?.toString();
    gender = json['gender']?.toString();
    profilePhoto = json['profilePhoto']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['coachId'] = coachId;
    data['coachName'] = coachName;
    data['gender'] = gender;
    data['profilePhoto'] = profilePhoto;
    return data;
  }
}

class UserNutritionDetailsModel {
/*
{
  "currentTrainer": {
    "coachId": "36362500-f846-11ec-b571-6d35ec14eac1",
    "coachName": "Dr. test trainer",
    "gender": "Male",
    "profilePhoto": ""
  },
  "selectedPackage": {
    "addOns": {
      "doctorSessions": 0,
      "therapistSessions": 0,
      "aayuSubscription": ""
    },
    "dietPlans": 2,
    "displayText": "4 Weeks",
    "duration": "4 Weeks",
    "durationInDays": 28,
    "packageId": "e95899c0-befb-11ed-a9a9-b9bd3cb9374a",
    "purchaseType": "FIRST TIME",
    "sessions": 2,
    "whatYouGet": [
      "2 Consultations"
    ],
    "packageType": "BASIC",
    "paymentOrderId": "123456",
    "startDate": 1678440376000,
    "endDate": 1680859576000
  },
  "status": "ACTIVE"
} 
*/

  UserNutritionDetailsModelCurrentTrainer? currentTrainer;
  UserNutritionDetailsModelSelectedPackage? selectedPackage;
  String? status;
  bool? showExtendPlan;

  UserNutritionDetailsModel({
    this.currentTrainer,
    this.selectedPackage,
    this.status,
    this.showExtendPlan,
  });
  UserNutritionDetailsModel.fromJson(Map<String, dynamic> json) {
    currentTrainer = (json['currentTrainer'] != null)
        ? UserNutritionDetailsModelCurrentTrainer.fromJson(
            json['currentTrainer'])
        : null;
    selectedPackage = (json['selectedPackage'] != null)
        ? UserNutritionDetailsModelSelectedPackage.fromJson(
            json['selectedPackage'])
        : null;
    status = json['status']?.toString();
    showExtendPlan = json['showExtendPlan'] ?? false;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (currentTrainer != null) {
      data['currentTrainer'] = currentTrainer!.toJson();
    }
    if (selectedPackage != null) {
      data['selectedPackage'] = selectedPackage!.toJson();
    }
    data['status'] = status;
    data['showExtendPlan'] = showExtendPlan ?? false;
    return data;
  }
}