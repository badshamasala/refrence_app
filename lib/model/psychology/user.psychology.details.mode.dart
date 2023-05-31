///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class UserPsychologyDetailsModelInitialAssessment {
/*
{
  "isCompleted": false,
  "completedDate": 1687305600000
} 
*/

  bool? isCompleted;
  int? completedDate;

  UserPsychologyDetailsModelInitialAssessment({
    this.isCompleted,
    this.completedDate,
  });
  UserPsychologyDetailsModelInitialAssessment.fromJson(Map<String, dynamic> json) {
    isCompleted = json['isCompleted'];
    completedDate = json['completedDate']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isCompleted'] = isCompleted;
    data['completedDate'] = completedDate;
    return data;
  }
}

class UserPsychologyDetailsModelConsent {
/*
{
  "isAccepted": false,
  "acceptedDate": 1687305600000
} 
*/

  bool? isAccepted;
  int? acceptedDate;

  UserPsychologyDetailsModelConsent({
    this.isAccepted,
    this.acceptedDate,
  });
  UserPsychologyDetailsModelConsent.fromJson(Map<String, dynamic> json) {
    isAccepted = json['isAccepted'];
    acceptedDate = json['acceptedDate']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isAccepted'] = isAccepted;
    data['acceptedDate'] = acceptedDate;
    return data;
  }
}

class UserPsychologyDetailsModelSelectedPackageAddOns {
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

  UserPsychologyDetailsModelSelectedPackageAddOns({
    this.doctorSessions,
    this.therapistSessions,
    this.aayuSubscription,
  });
  UserPsychologyDetailsModelSelectedPackageAddOns.fromJson(Map<String, dynamic> json) {
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

class UserPsychologyDetailsModelSelectedPackage {
/*
{
  "addOns": {
    "doctorSessions": 0,
    "therapistSessions": 0,
    "aayuSubscription": ""
  },
  "displayText": "(Introduction)",
  "duration": "4 Weeks",
  "durationInDays": 28,
  "packageId": "e11a8790-d793-11ed-aebc-b5392c20a7dc",
  "packageType": "EXPERTS",
  "purchaseType": "FIRST TIME",
  "sessions": 1,
  "whatYouGet": [
    "4 online consultations"
  ],
  "paymentOrderId": "1684833422955",
  "startDate": 1684833430000,
  "endDate": 1687305600000
} 
*/

  UserPsychologyDetailsModelSelectedPackageAddOns? addOns;
  String? displayText;
  String? duration;
  int? durationInDays;
  String? packageId;
  String? packageType;
  String? purchaseType;
  int? sessions;
  List<String?>? whatYouGet;
  String? paymentOrderId;
  int? startDate;
  int? endDate;

  UserPsychologyDetailsModelSelectedPackage({
    this.addOns,
    this.displayText,
    this.duration,
    this.durationInDays,
    this.packageId,
    this.packageType,
    this.purchaseType,
    this.sessions,
    this.whatYouGet,
    this.paymentOrderId,
    this.startDate,
    this.endDate,
  });
  UserPsychologyDetailsModelSelectedPackage.fromJson(Map<String, dynamic> json) {
    addOns = (json['addOns'] != null) ? UserPsychologyDetailsModelSelectedPackageAddOns.fromJson(json['addOns']) : null;
    displayText = json['displayText']?.toString();
    duration = json['duration']?.toString();
    durationInDays = json['durationInDays']?.toInt();
    packageId = json['packageId']?.toString();
    packageType = json['packageType']?.toString();
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
    paymentOrderId = json['paymentOrderId']?.toString();
    startDate = json['startDate']?.toInt();
    endDate = json['endDate']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (addOns != null) {
      data['addOns'] = addOns!.toJson();
    }
    data['displayText'] = displayText;
    data['duration'] = duration;
    data['durationInDays'] = durationInDays;
    data['packageId'] = packageId;
    data['packageType'] = packageType;
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
    data['paymentOrderId'] = paymentOrderId;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    return data;
  }
}

class UserPsychologyDetailsModel {
/*
{
  "userPsychologyMasterId": "988fa400-f94a-11ed-8889-8156890740fe",
  "selectedPackage": {
    "addOns": {
      "doctorSessions": 0,
      "therapistSessions": 0,
      "aayuSubscription": ""
    },
    "displayText": "(Introduction)",
    "duration": "4 Weeks",
    "durationInDays": 28,
    "packageId": "e11a8790-d793-11ed-aebc-b5392c20a7dc",
    "packageType": "EXPERTS",
    "purchaseType": "FIRST TIME",
    "sessions": 1,
    "whatYouGet": [
      "4 online consultations"
    ],
    "paymentOrderId": "1684833422955",
    "startDate": 1684833430000,
    "endDate": 1687305600000
  },
  "consent": {
    "isAccepted": false,
    "acceptedDate": 1687305600000
  },
  "initialAssessment": {
    "isCompleted": false,
    "completedDate": 1687305600000
  },
  "showExtendPlan": false,
  "status": "ACTIVE"
} 
*/

  String? userPsychologyMasterId;
  UserPsychologyDetailsModelSelectedPackage? selectedPackage;
  UserPsychologyDetailsModelConsent? consent;
  UserPsychologyDetailsModelInitialAssessment? initialAssessment;
  bool? showExtendPlan;
  String? status;

  UserPsychologyDetailsModel({
    this.userPsychologyMasterId,
    this.selectedPackage,
    this.consent,
    this.initialAssessment,
    this.showExtendPlan,
    this.status,
  });
  UserPsychologyDetailsModel.fromJson(Map<String, dynamic> json) {
    userPsychologyMasterId = json['userPsychologyMasterId']?.toString();
    selectedPackage = (json['selectedPackage'] != null) ? UserPsychologyDetailsModelSelectedPackage.fromJson(json['selectedPackage']) : null;
    consent = (json['consent'] != null) ? UserPsychologyDetailsModelConsent.fromJson(json['consent']) : null;
    initialAssessment = (json['initialAssessment'] != null) ? UserPsychologyDetailsModelInitialAssessment.fromJson(json['initialAssessment']) : null;
    showExtendPlan = json['showExtendPlan'];
    status = json['status']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userPsychologyMasterId'] = userPsychologyMasterId;
    if (selectedPackage != null) {
      data['selectedPackage'] = selectedPackage!.toJson();
    }
    if (consent != null) {
      data['consent'] = consent!.toJson();
    }
    if (initialAssessment != null) {
      data['initialAssessment'] = initialAssessment!.toJson();
    }
    data['showExtendPlan'] = showExtendPlan;
    data['status'] = status;
    return data;
  }
}
