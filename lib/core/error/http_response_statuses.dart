extension HttpStatusMessages on int {
  String getMessage([String? customMessage]) {
    switch (this) {
      case 200:
        return customMessage ?? "Success";
      case 201:
        return customMessage ?? "Created";
      case 204:
        return customMessage ?? "No Content";
      case 400:
        return customMessage ?? "Bad Request";
      case 401:
        return customMessage ?? "Unauthorized";
      case 403:
        return customMessage ?? "Forbidden";
      case 404:
        return customMessage ?? "Not Found";
      case 500:
        return customMessage ?? "Internal Server Error";
      case 503:
        return customMessage ?? "Service Unavailable";
      default:
        return "Unknown Status Code";
    }
  }
}
