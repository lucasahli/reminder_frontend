import 'dart:convert';

class RefreshToken {
  String token;
  DateTime expiration;

  RefreshToken(this.token, this.expiration);

  bool isValid() {
    return expiration.isAfter(DateTime.now());
  }

  @override
  String toString() {
    return '$token';
  }

  String toJson() {
    return jsonEncode({
      'token': token,
      'expiration': expiration.toIso8601String(),
    });
  }

  // Create a RefreshToken object from a JSON string
  static RefreshToken fromJson(String source) {
    Map<String, dynamic> data = jsonDecode(source);
    return RefreshToken(
      data['token'],
      DateTime.parse(data['expiration']),
    );
  }
}
