import '../../../../core/common/entities/transaction/transasction_entity.dart';

class TransactionModel extends TransactionEntity {
  TransactionModel({
    required super.transactionId,
    required super.userId,
    required super.transactionType,
    required super.transactionCategory,
    required super.transactionAmount,
    required super.transactionFee,
    required super.totalAmount,
    required super.createdAt,
    required super.transactionStatus,
    required super.id,
    required super.beneficiaryId,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transactionId: json["transactionID"],
      userId: TrxUserModel.fromJson(json["userID"]),
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
          : TrxBeneficiaryModel.fromJson(json["beneficiaryID"]),
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

class TrxBeneficiaryModel extends TrxBeneficiaryEntity {
  TrxBeneficiaryModel({
    required super.nickname,
    required super.id,
    required super.phoneNumber,
  });

  factory TrxBeneficiaryModel.fromJson(Map<String, dynamic> json) {
    return TrxBeneficiaryModel(
        nickname: json["nickname"],
        id: json["id"],
        phoneNumber: json["phoneNumber"]);
  }

  Map<String, dynamic> toJson() => {
        "nickname": nickname,
        "id": id,
        "phoneNumber": phoneNumber,
      };
}

class TrxUserModel extends TrxUserEntity {
  TrxUserModel({
    required super.name,
    required super.id,
  });

  factory TrxUserModel.fromJson(Map<String, dynamic> json) {
    return TrxUserModel(
      name: json["name"],
      id: json["id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}
