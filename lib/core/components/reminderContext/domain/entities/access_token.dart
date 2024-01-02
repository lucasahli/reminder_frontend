import 'dart:convert';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class AccessToken {
  final String bearerToken;
  late final BearerTokenPayload payload;

  static String _stripBearerPrefix(String token) {
    const prefix = 'Bearer ';
    return token.startsWith(prefix) ? token.substring(prefix.length) : token;
  }

  AccessToken(String tokenString)
      : bearerToken = _stripBearerPrefix(tokenString) {
    // Decode the JWT to extract payload for validation and expiration checks.
    // This assumes the token is a JWT. If it's not, you'll need a different approach.
    final parts = bearerToken.split('.');
    if (parts.length != 3) {
      throw FormatException('Invalid token format');
    }

    final payloadPart = parts[1];
    final String decodedJson = B64urlEncRfc7515.decodeUtf8(payloadPart);
    final Map<String, dynamic> payloadMap = json.decode(decodedJson);
    payload = BearerTokenPayload.fromJson(payloadMap);
  }

  bool get isExpired {
    final expiryDate = payload.exp;
    if (expiryDate == null) return false; // Token does not expire.
    return DateTime.now().toUtc().isAfter(expiryDate);
  }

  bool get isValid {
    // Implement additional checks for validity if necessary.
    // For example, you might want to check the token's issuer, audience, etc.
    return !isExpired;
  }

  @override
  String toString() {
    return 'Bearer $bearerToken';
  }
}

class BearerTokenPayload {
  final DateTime? exp; // Expiration date

  BearerTokenPayload({this.exp});

  factory BearerTokenPayload.fromJson(Map<String, dynamic> json) {
    return BearerTokenPayload(
      exp: json.containsKey('exp')
          ? DateTime.fromMillisecondsSinceEpoch(json['exp'] * 1000, isUtc: true)
          : null,
    );
  }
}
