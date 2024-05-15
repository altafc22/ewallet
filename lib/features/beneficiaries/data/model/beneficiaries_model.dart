import 'beneficiary_model.dart';

class BeneficiariesModel {
  BeneficiariesModel({
    required this.status,
    required this.message,
    required this.beneficiaries,
  });

  final bool? status;
  final String? message;
  final List<BeneficiaryModel> beneficiaries;

  factory BeneficiariesModel.fromJson(Map<String, dynamic> json) {
    return BeneficiariesModel(
      status: json["status"],
      message: json["message"],
      beneficiaries: json["beneficiaries"] == null
          ? []
          : List<BeneficiaryModel>.from(
              json["beneficiaries"]!.map((x) => BeneficiaryModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "beneficiaries": beneficiaries.map((x) => x.toJson()).toList(),
      };
}
