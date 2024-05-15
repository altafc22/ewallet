class BeneficiaryEntity {
  BeneficiaryEntity({
    required this.id,
    required this.userId,
    required this.nickname,
    required this.phoneNumber,
    required this.balance,
    required this.isActive,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String nickname;
  final String phoneNumber;
  final DateTime? createdAt;
  final num balance;
  final bool isActive;
}
