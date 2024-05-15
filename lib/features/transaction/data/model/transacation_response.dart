class TransactionsResponse {
  TransactionsResponse({
    required this.status,
    required this.message,
    required this.transactions,
  });

  final bool? status;
  final String? message;
  final List<Transaction> transactions;

  factory TransactionsResponse.fromJson(Map<String, dynamic> json) {
    return TransactionsResponse(
      status: json["status"],
      message: json["message"],
      transactions: json["transactions"] == null
          ? []
          : List<Transaction>.from(
              json["transactions"]!.map((x) => Transaction.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "transactions": transactions.map((x) => x.toJson()).toList(),
      };
}

class Transaction {
  Transaction({
    required this.transactionId,
    required this.userId,
    required this.transactionType,
    required this.transactionCategory,
    required this.transactionAmount,
    required this.transactionFee,
    required this.totalAmount,
    required this.createdAt,
    required this.transactionStatus,
    required this.id,
    required this.beneficiaryId,
  });

  final String? transactionId;
  final UserId? userId;
  final String? transactionType;
  final String? transactionCategory;
  final num? transactionAmount;
  final num? transactionFee;
  final num? totalAmount;
  final DateTime? createdAt;
  final String? transactionStatus;
  final String? id;
  final BeneficiaryId? beneficiaryId;

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: json["transactionID"],
      userId: json["userID"] == null ? null : UserId.fromJson(json["userID"]),
      transactionType: json["transactionType"],
      transactionCategory: json["transactionCategory"],
      transactionAmount: json["transactionAmount"],
      transactionFee: json["transactionFee"],
      totalAmount: json["totalAmount"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      transactionStatus: json["transactionStatus"],
      id: json["id"],
      beneficiaryId: json["beneficiaryID"] == null
          ? null
          : BeneficiaryId.fromJson(json["beneficiaryID"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "transactionID": transactionId,
        "userID": userId?.toJson(),
        "transactionType": transactionType,
        "transactionCategory": transactionCategory,
        "transactionAmount": transactionAmount,
        "transactionFee": transactionFee,
        "totalAmount": totalAmount,
        "createdAt": createdAt?.toIso8601String(),
        "transactionStatus": transactionStatus,
        "id": id,
        "beneficiaryID": beneficiaryId?.toJson(),
      };
}

class BeneficiaryId {
  BeneficiaryId({
    required this.nickname,
    required this.id,
    required this.phoneNumber,
  });

  final String? nickname;
  final String? id;
  final String? phoneNumber;

  factory BeneficiaryId.fromJson(Map<String, dynamic> json) {
    return BeneficiaryId(
      nickname: json["nickname"],
      id: json["id"],
      phoneNumber: json["phoneNumber"],
    );
  }

  Map<String, dynamic> toJson() =>
      {"nickname": nickname, "id": id, "phoneNumber": phoneNumber};
}

class UserId {
  UserId({
    required this.name,
    required this.id,
  });

  final String? name;
  final String? id;

  factory UserId.fromJson(Map<String, dynamic> json) {
    return UserId(
      name: json["name"],
      id: json["id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}
