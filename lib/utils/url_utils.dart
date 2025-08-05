class UrlUtils {
  static String? getPatientIdFromUrl() {
    final url = Uri.base;
    return url.queryParameters['token'];
  }
}
