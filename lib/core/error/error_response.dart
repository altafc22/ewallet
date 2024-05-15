class ErrorResponse {
  String? message;
  bool? status;
  ErrorResponse({required this.status, required this.message});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
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
