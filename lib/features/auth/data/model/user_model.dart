import '../../../../core/common/entities/auth/user_entity.dart';

class UserModel extends UserEntity {
  UserModel(
      {required super.username,
      required super.name,
      required super.phone,
      required super.isVerified,
      required super.balance,
      required super.id});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json["username"] ?? '',
      name: json["name"] ?? '',
      phone: json["phone"] ?? '',
      isVerified: json["isVerified"] ?? false,
      balance: json["balance"] ?? 0,
      id: json["id"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "name": name,
        "phone": phone,
        "isVerified": isVerified,
        "balance": balance,
        "id": id,
      };
}
