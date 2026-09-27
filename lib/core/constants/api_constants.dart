class ApiConstants {
  // Base URL sonu mutlaka '/' ile bitmeli
  static const String baseUrl = 'http://192.168.1.8:5000/api/';

  // Kimlik Doğrulama
  static const String loginEndpoint = "Account/login";
  static const String registerEndpoint = "Account/register";

  // Modüller
  static const String productsEndpoint = "Products";
  static const String categoriesEndpoint = "Categories";
  static const String commentsEndpoint = "Comments";
  static const String ordersEndpoint = "Orders";

  static const Duration timeout = Duration(seconds: 10);
}