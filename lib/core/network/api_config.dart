class ApiConfig {
  ApiConfig._();

  static const String baseUrl = "http://localhost:5001/api/v1";

  static const Duration receiveTimeout = Duration(milliseconds: 15000);
  static const Duration connectionTimeout = Duration(milliseconds: 15000);

  static const String auth = '/auth';
  static const String loginUser = '$auth/login';
  static const String logoutUser = '$auth/logout';
  static const String registerUser = '$auth/register';

  static const String users = '/users';

  static const String profile = '$users/profile';

  static const String transactions = '/transactions';
  static const String topup = '$transactions/topup';
  static const String recharge = '$transactions/recharge';
  //static const String transactionByUser = '$transactions/user';
  static const String transactionByBeneficiary = '$transactions/beneficiary';

  static const String beneficiaries = '/beneficiaries';
}
