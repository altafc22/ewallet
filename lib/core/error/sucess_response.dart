class SucessResponse {
  String? message;
  bool? status;
  SucessResponse({required this.status, required this.message});

  factory SucessResponse.fromJson(Map<String, dynamic> json) {
    return SucessResponse(
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status ?? false,
      'message': message,
    };
  }
}
