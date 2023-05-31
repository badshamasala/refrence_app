///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class PsychologyPlansModelPackagesCurrency {
/*
{
  "display": "₹",
  "billing": "INR"
} 
*/

  String? display;
  String? billing;

  PsychologyPlansModelPackagesCurrency({
    this.display,
    this.billing,
  });
  PsychologyPlansModelPackagesCurrency.fromJson(Map<String, dynamic> json) {
    display = json['display']?.toString();
    billing = json['billing']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['display'] = display;
    data['billing'] = billing;
    return data;
  }
}

class PsychologyPlansModelPackagesAddOns {
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

  PsychologyPlansModelPackagesAddOns({
    this.doctorSessions,
    this.therapistSessions,
    this.aayuSubscription,
  });
  PsychologyPlansModelPackagesAddOns.fromJson(Map<String, dynamic> json) {
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

class PsychologyPlansModelPackagesDuration {
/*
{
  "display": "4 Weeks",
  "inDays": 28
} 
*/

  String? display;
  int? inDays;

  PsychologyPlansModelPackagesDuration({
    this.display,
    this.inDays,
  });
  PsychologyPlansModelPackagesDuration.fromJson(Map<String, dynamic> json) {
    display = json['display']?.toString();
    inDays = json['inDays']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['display'] = display;
    data['inDays'] = inDays;
    return data;
  }
}

class PsychologyPlansModelPackages {
/*
{
  "packageId": "e11a8790-d793-11ed-aebc-b5392c20a7dc",
  "packageName": "FIRST_TIME_EXPERTS_4_WEEKS_SESSION_4",
  "displayText": "4 Weeks",
  "packageType": "EXPERTS",
  "purchaseType": "FIRST TIME",
  "recommended": true,
  "recommendedText": "",
  "sessions": 4,
  "duration": {
    "display": "4 Weeks",
    "inDays": 28
  },
  "addOns": {
    "doctorSessions": 0,
    "therapistSessions": 0,
    "aayuSubscription": ""
  },
  "whatYouGet": [
    "4 online consultations"
  ],
  "enabled": true,
  "currency": {
    "display": "₹",
    "billing": "INR"
  },
  "country": "IN",
  "consultingCharges": 500,
  "isPercentage": true,
  "discount": 5,
  "purchaseAmount": 475,
  "countryPackageId": "db9a8b20-d799-11ed-bcf6-71b9a5effa1d"
} 
*/

  String? packageId;
  String? packageName;
  String? displayText;
  String? packageType;
  String? purchaseType;
  bool? recommended;
  String? recommendedText;
  int? sessions;
  PsychologyPlansModelPackagesDuration? duration;
  PsychologyPlansModelPackagesAddOns? addOns;
  List<String?>? whatYouGet;
  bool? enabled;
  PsychologyPlansModelPackagesCurrency? currency;
  String? country;
  double? consultingCharges;
  bool? isPercentage;
  double? discount;
  double? offerAmount;
  double? purchaseAmount;
  String? countryPackageId;

  PsychologyPlansModelPackages({
    this.packageId,
    this.packageName,
    this.displayText,
    this.packageType,
    this.purchaseType,
    this.recommended,
    this.recommendedText,
    this.sessions,
    this.duration,
    this.addOns,
    this.whatYouGet,
    this.enabled,
    this.currency,
    this.country,
    this.consultingCharges,
    this.isPercentage,
    this.discount,
    this.purchaseAmount,
    this.offerAmount,
    this.countryPackageId,
  });
  PsychologyPlansModelPackages.fromJson(Map<String, dynamic> json) {
    packageId = json['packageId']?.toString();
    packageName = json['packageName']?.toString();
    displayText = json['displayText']?.toString();
    packageType = json['packageType']?.toString();
    purchaseType = json['purchaseType']?.toString();
    recommended = json['recommended'];
    recommendedText = json['recommendedText']?.toString();
    sessions = json['sessions']?.toInt();
    duration = (json['duration'] != null)
        ? PsychologyPlansModelPackagesDuration.fromJson(json['duration'])
        : null;
    addOns = (json['addOns'] != null)
        ? PsychologyPlansModelPackagesAddOns.fromJson(json['addOns'])
        : null;
    if (json['whatYouGet'] != null) {
      final v = json['whatYouGet'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      whatYouGet = arr0;
    }
    enabled = json['enabled'];
    currency = (json['currency'] != null)
        ? PsychologyPlansModelPackagesCurrency.fromJson(json['currency'])
        : null;
    country = json['country']?.toString();
    consultingCharges = json['consultingCharges']?.toDouble();
    isPercentage = json['isPercentage'];
    discount = json['discount']?.toDouble();
    purchaseAmount = json['purchaseAmount']?.toDouble();
    offerAmount = json['offerAmount']?.toDouble();

    countryPackageId = json['countryPackageId']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['packageId'] = packageId;
    data['packageName'] = packageName;
    data['displayText'] = displayText;
    data['packageType'] = packageType;
    data['purchaseType'] = purchaseType;
    data['recommended'] = recommended;
    data['recommendedText'] = recommendedText;
    data['sessions'] = sessions;
    if (duration != null) {
      data['duration'] = duration!.toJson();
    }
    if (addOns != null) {
      data['addOns'] = addOns!.toJson();
    }
    if (whatYouGet != null) {
      final v = whatYouGet;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v);
      }
      data['whatYouGet'] = arr0;
    }
    data['enabled'] = enabled;
    if (currency != null) {
      data['currency'] = currency!.toJson();
    }
    data['country'] = country;
    data['consultingCharges'] = consultingCharges;
    data['isPercentage'] = isPercentage;
    data['discount'] = discount;
    data['purchaseAmount'] = purchaseAmount;
    data['offerAmount'] = offerAmount;

    data['countryPackageId'] = countryPackageId;
    return data;
  }
}

class PsychologyPlansModel {
/*
{
  "isBillingAllowed": true,
  "packages": [
    {
      "packageId": "e11a8790-d793-11ed-aebc-b5392c20a7dc",
      "packageName": "FIRST_TIME_EXPERTS_4_WEEKS_SESSION_4",
      "displayText": "4 Weeks",
      "packageType": "EXPERTS",
      "purchaseType": "FIRST TIME",
      "recommended": true,
      "recommendedText": "",
      "sessions": 4,
      "duration": {
        "display": "4 Weeks",
        "inDays": 28
      },
      "addOns": {
        "doctorSessions": 0,
        "therapistSessions": 0,
        "aayuSubscription": ""
      },
      "whatYouGet": [
        "4 online consultations"
      ],
      "enabled": true,
      "currency": {
        "display": "₹",
        "billing": "INR"
      },
      "country": "IN",
      "consultingCharges": 500,
      "isPercentage": true,
      "discount": 5,
      "purchaseAmount": 475,
      "countryPackageId": "db9a8b20-d799-11ed-bcf6-71b9a5effa1d"
    }
  ]
} 
*/

  bool? isBillingAllowed;
  List<PsychologyPlansModelPackages?>? packages;

  PsychologyPlansModel({
    this.isBillingAllowed,
    this.packages,
  });
  PsychologyPlansModel.fromJson(Map<String, dynamic> json) {
    isBillingAllowed = json['isBillingAllowed'];
    if (json['packages'] != null) {
      final v = json['packages'];
      final arr0 = <PsychologyPlansModelPackages>[];
      v.forEach((v) {
        arr0.add(PsychologyPlansModelPackages.fromJson(v));
      });
      packages = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isBillingAllowed'] = isBillingAllowed;
    if (packages != null) {
      final v = packages;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data['packages'] = arr0;
    }
    return data;
  }
}
