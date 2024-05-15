class UserEntity {
  final String? username;
  final String? name;
  final String? phone;
  final bool? isVerified;
  final num? balance;
  final String? id;

  UserEntity({
    required this.username,
    required this.name,
    required this.phone,
    required this.isVerified,
    required this.balance,
    required this.id,
  });
}
