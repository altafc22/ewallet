class TransactionEntity {
  TransactionEntity({
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
  final TrxUserEntity? userId;
  final String? transactionType;
  final String? transactionCategory;
  final num? transactionAmount;
  final num? transactionFee;
  final num? totalAmount;
  final DateTime? createdAt;
  final String? transactionStatus;
  final String? id;
  final TrxBeneficiaryEntity? beneficiaryId;
}

class TrxBeneficiaryEntity {
  TrxBeneficiaryEntity({
    required this.nickname,
    required this.id,
    required this.phoneNumber,
  });

  final String? nickname;
  final String? id;
  final String? phoneNumber;

  Map<String, dynamic> toJson() => {
        "nickname": nickname,
        "id": id,
        "phoneNumber": phoneNumber,
      };
}

class TrxUserEntity {
  TrxUserEntity({
    required this.name,
    required this.id,
  });

  final String? name;
  final String? id;

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}
