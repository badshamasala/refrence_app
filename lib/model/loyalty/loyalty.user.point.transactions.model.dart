///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class LoyaltyUserPointTransactionsModelPaginationNext {
/*
{
  "page": 2,
  "limit": 10
} 
*/

  int? page;
  int? limit;

  LoyaltyUserPointTransactionsModelPaginationNext({
    this.page,
    this.limit,
  });
  LoyaltyUserPointTransactionsModelPaginationNext.fromJson(Map<String, dynamic> json) {
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

class LoyaltyUserPointTransactionsModelPaginationPrevious {
/*
{
  "page": 1,
  "limit": 10
} 
*/

  int? page;
  int? limit;

  LoyaltyUserPointTransactionsModelPaginationPrevious({
    this.page,
    this.limit,
  });
  LoyaltyUserPointTransactionsModelPaginationPrevious.fromJson(Map<String, dynamic> json) {
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

class LoyaltyUserPointTransactionsModelPagination {
/*
{
  "previous": {
    "page": 1,
    "limit": 10
  },
  "next": {
    "page": 2,
    "limit": 10
  }
} 
*/

  LoyaltyUserPointTransactionsModelPaginationPrevious? previous;
  LoyaltyUserPointTransactionsModelPaginationNext? next;

  LoyaltyUserPointTransactionsModelPagination({
    this.previous,
    this.next,
  });
  LoyaltyUserPointTransactionsModelPagination.fromJson(Map<String, dynamic> json) {
    previous = (json['previous'] != null && (json['previous'] is Map)) ? LoyaltyUserPointTransactionsModelPaginationPrevious.fromJson(json['previous']) : null;
    next = (json['next'] != null && (json['next'] is Map)) ? LoyaltyUserPointTransactionsModelPaginationNext.fromJson(json['next']) : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (previous != null) {
      data['previous'] = previous!.toJson();
    }
    if (next != null) {
      data['next'] = next!.toJson();
    }
    return data;
  }
}

class LoyaltyUserPointTransactionsModelResult {
/*
{
  "transactionId": "5e3bac40-d7a8-11ed-b653-111daa4622bd",
  "source": "APP_EVENTS",
  "referenceId": "e270d830-c7ce-11ed-88d0-99ed3dac0d51",
  "transactionType": "CREDIT",
  "displayText": "Content Completed",
  "description": "Content Completed",
  "theme": "#A0BDF1",
  "vPoints": 1,
  "mPoints": 0,
  "expiresOn": 1681135365380,
  "updatedAt": 1681135365380,
  "createdAt": 1681135365380
} 
*/

  String? transactionId;
  String? source;
  String? referenceId;
  String? transactionType;
  String? displayText;
  String? description;
  String? theme;
  String? icon;
  int? vPoints;
  int? mPoints;
  int? expiresOn;
  int? updatedAt;
  int? createdAt;

  LoyaltyUserPointTransactionsModelResult({
    this.transactionId,
    this.source,
    this.referenceId,
    this.transactionType,
    this.displayText,
    this.description,
    this.theme,
    this.icon,
    this.vPoints,
    this.mPoints,
    this.expiresOn,
    this.updatedAt,
    this.createdAt,
  });
  LoyaltyUserPointTransactionsModelResult.fromJson(Map<String, dynamic> json) {
    transactionId = json['transactionId']?.toString();
    source = json['source']?.toString();
    referenceId = json['referenceId']?.toString();
    transactionType = json['transactionType']?.toString();
    displayText = json['displayText']?.toString();
    description = json['description']?.toString();
    theme = json['theme']?.toString();
    icon = json['icon']?.toString();
    vPoints = int.tryParse(json['vPoints']?.toString() ?? '');
    mPoints = int.tryParse(json['mPoints']?.toString() ?? '');
    expiresOn = int.tryParse(json['expiresOn']?.toString() ?? '');
    updatedAt = int.tryParse(json['updatedAt']?.toString() ?? '');
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
    data['theme'] = theme;
    data['icon'] = icon;
    data['vPoints'] = vPoints;
    data['mPoints'] = mPoints;
    data['expiresOn'] = expiresOn;
    data['updatedAt'] = updatedAt;
    data['createdAt'] = createdAt;
    return data;
  }
}

class LoyaltyUserPointTransactionsModel {
/*
{
  "result": [
    {
      "transactionId": "5e3bac40-d7a8-11ed-b653-111daa4622bd",
      "source": "APP_EVENTS",
      "referenceId": "e270d830-c7ce-11ed-88d0-99ed3dac0d51",
      "transactionType": "CREDIT",
      "displayText": "Content Completed",
      "description": "Content Completed",
      "theme": "#A0BDF1",
      "vPoints": 1,
      "mPoints": 0,
      "expiresOn": 1681135365380,
      "updatedAt": 1681135365380,
      "createdAt": 1681135365380
    }
  ],
  "pagination": {
    "previous": {
      "page": 1,
      "limit": 10
    },
    "next": {
      "page": 2,
      "limit": 10
    }
  }
} 
*/

  List<LoyaltyUserPointTransactionsModelResult?>? result;
  LoyaltyUserPointTransactionsModelPagination? pagination;

  LoyaltyUserPointTransactionsModel({
    this.result,
    this.pagination,
  });
  LoyaltyUserPointTransactionsModel.fromJson(Map<String, dynamic> json) {
  if (json['result'] != null && (json['result'] is List)) {
  final v = json['result'];
  final arr0 = <LoyaltyUserPointTransactionsModelResult>[];
  v.forEach((v) {
  arr0.add(LoyaltyUserPointTransactionsModelResult.fromJson(v));
  });
    result = arr0;
    }
    pagination = (json['pagination'] != null && (json['pagination'] is Map)) ? LoyaltyUserPointTransactionsModelPagination.fromJson(json['pagination']) : null;
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
