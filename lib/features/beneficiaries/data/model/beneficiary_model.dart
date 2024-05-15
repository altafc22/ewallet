import 'package:ewallet/features/beneficiaries/domain/entitiy/beneficiary_entity.dart';

class BeneficiaryModel extends BeneficiaryEntity {
  BeneficiaryModel({
    required super.id,
    required super.userId,
    required super.nickname,
    required super.phoneNumber,
    required super.balance,
    required super.isActive,
    required super.createdAt,
  });

  factory BeneficiaryModel.fromJson(Map<String, dynamic> json) {
    return BeneficiaryModel(
      id: json["id"] ?? "",
      userId: json["userID"] ?? "",
      nickname: json["nickname"] ?? "",
      phoneNumber: json["phoneNumber"] ?? "",
      balance: json["balance"] ?? 0,
      isActive: json["isActive"] ?? false,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "userID": userId,
        "nickname": nickname,
        "phoneNumber": phoneNumber,
        "balance": balance,
        "isActive": isActive,
        "createdAt": createdAt?.toIso8601String()
      };
}
