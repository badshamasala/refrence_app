///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class LoyaltyUserPendingPointsModelPaginationPrevious {
/*
{
  "page": 1,
  "limit": 10
} 
*/

  int? page;
  int? limit;

  LoyaltyUserPendingPointsModelPaginationPrevious({
    this.page,
    this.limit,
  });
  LoyaltyUserPendingPointsModelPaginationPrevious.fromJson(Map<String, dynamic> json) {
    page = int.tryParse(json['page']?.toString() ?? '');
    limit = int.tryParse(json['limit']?.toString() ?? '');
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['page'] = page;
    data['limit'] = limit;
    return data;
  }
}

class LoyaltyUserPendingPointsModelPaginationNext {
/*
{
  "page": 2,
  "limit": 10
} 
*/

  int? page;
  int? limit;

  LoyaltyUserPendingPointsModelPaginationNext({
    this.page,
    this.limit,
  });
  LoyaltyUserPendingPointsModelPaginationNext.fromJson(Map<String, dynamic> json) {
    page = int.tryParse(json['page']?.toString() ?? '');
    limit = int.tryParse(json['limit']?.toString() ?? '');
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['page'] = page;
    data['limit'] = limit;
    return data;
  }
}

class LoyaltyUserPendingPointsModelPagination {
/*
{
  "next": {
    "page": 2,
    "limit": 10
  },
  "previous": {
    "page": 1,
    "limit": 10
  }
} 
*/

  LoyaltyUserPendingPointsModelPaginationNext? next;
  LoyaltyUserPendingPointsModelPaginationPrevious? previous;

  LoyaltyUserPendingPointsModelPagination({
    this.next,
    this.previous,
  });
  LoyaltyUserPendingPointsModelPagination.fromJson(Map<String, dynamic> json) {
    next = (json['next'] != null && (json['next'] is Map)) ? LoyaltyUserPendingPointsModelPaginationNext.fromJson(json['next']) : null;
    previous = (json['previous'] != null && (json['previous'] is Map)) ? LoyaltyUserPendingPointsModelPaginationPrevious.fromJson(json['previous']) : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (next != null) {
      data['next'] = next!.toJson();
    }
    if (previous != null) {
      data['previous'] = previous!.toJson();
    }
    return data;
  }
}

class LoyaltyUserPendingPointsModelResult {
/*
{
  "transactionId": "fafd5080-d936-11ed-b1db-3328881f1c45",
  "source": "APP_EVENTS",
  "referenceId": "571d6cd0-c7ce-11ed-88d0-99ed3dac0d51",
  "transactionType": "CREDIT",
  "displayText": "Daily App Open",
  "description": "Daily App Open",
  "icon": "https://stg-content.aayu.live/aayu/loyalty/event/dailylive.png",
  "theme": "#75C8E1",
  "vPoints": 5,
  "mPoints": 0,
  "expiresOn": 1681306568076,
  "createdAt": 1681306568076
} 
*/

  String? transactionId;
  String? source;
  String? referenceId;
  String? transactionType;
  String? displayText;
  String? description;
  String? icon;
  String? theme;
  int? vPoints;
  int? mPoints;
  int? expiresOn;
  int? createdAt;

  LoyaltyUserPendingPointsModelResult({
    this.transactionId,
    this.source,
    this.referenceId,
    this.transactionType,
    this.displayText,
    this.description,
    this.icon,
    this.theme,
    this.vPoints,
    this.mPoints,
    this.expiresOn,
    this.createdAt,
  });
  LoyaltyUserPendingPointsModelResult.fromJson(Map<String, dynamic> json) {
    transactionId = json['transactionId']?.toString();
    source = json['source']?.toString();
    referenceId = json['referenceId']?.toString();
    transactionType = json['transactionType']?.toString();
    displayText = json['displayText']?.toString();
    description = json['description']?.toString();
    icon = json['icon']?.toString();
    theme = json['theme']?.toString();
    vPoints = int.tryParse(json['vPoints']?.toString() ?? '');
    mPoints = int.tryParse(json['mPoints']?.toString() ?? '');
    expiresOn = int.tryParse(json['expiresOn']?.toString() ?? '');
    createdAt = int.tryParse(json['createdAt']?.toString() ?? '');
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['transactionId'] = transactionId;
    data['source'] = source;
    data['referenceId'] = referenceId;
    data['transactionType'] = transactionType;
    data['displayText'] = displayText;
    data['description'] = description;
    data['icon'] = icon;
    data['theme'] = theme;
    data['vPoints'] = vPoints;
    data['mPoints'] = mPoints;
    data['expiresOn'] = expiresOn;
    data['createdAt'] = createdAt;
    return data;
  }
}

class LoyaltyUserPendingPointsModel {
/*
{
  "result": [
    {
      "transactionId": "fafd5080-d936-11ed-b1db-3328881f1c45",
      "source": "APP_EVENTS",
      "referenceId": "571d6cd0-c7ce-11ed-88d0-99ed3dac0d51",
      "transactionType": "CREDIT",
      "displayText": "Daily App Open",
      "description": "Daily App Open",
      "icon": "https://stg-content.aayu.live/aayu/loyalty/event/dailylive.png",
      "theme": "#75C8E1",
      "vPoints": 5,
      "mPoints": 0,
      "expiresOn": 1681306568076,
      "createdAt": 1681306568076
    }
  ],
  "pagination": {
    "next": {
      "page": 2,
      "limit": 10
    },
    "previous": {
      "page": 1,
      "limit": 10
    }
  }
} 
*/

  List<LoyaltyUserPendingPointsModelResult?>? result;
  LoyaltyUserPendingPointsModelPagination? pagination;

  LoyaltyUserPendingPointsModel({
    this.result,
    this.pagination,
  });
  LoyaltyUserPendingPointsModel.fromJson(Map<String, dynamic> json) {
  if (json['result'] != null && (json['result'] is List)) {
  final v = json['result'];
  final arr0 = <LoyaltyUserPendingPointsModelResult>[];
  v.forEach((v) {
  arr0.add(LoyaltyUserPendingPointsModelResult.fromJson(v));
  });
    result = arr0;
    }
    pagination = (json['pagination'] != null && (json['pagination'] is Map)) ? LoyaltyUserPendingPointsModelPagination.fromJson(json['pagination']) : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (result != null) {
      final v = result;
      final arr0 = [];
  v!.forEach((v) {
  arr0.add(v!.toJson());
  });
      data['result'] = arr0;
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}