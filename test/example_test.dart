import 'package:test/test.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:getsecure/getsecure.dart'; // Adjust this import based on the actual location

void main() {
  group('secureLink', () {
    test('generates a valid secure link with MD5 hash and expiration', () {
      String baselink = 'https://example.com/resource';
      String secret = 'my_secret_key';
      int period = 30;

      String result = secureLink(baselink, secret, period: period);
      Uri uri = Uri.parse(result);

      expect(uri.queryParameters.containsKey('md5'), isTrue);
      expect(uri.queryParameters.containsKey('expires'), isTrue);

      int expires = int.parse(uri.queryParameters['expires']!);
      expect(expires, greaterThan(DateTime.now().millisecondsSinceEpoch ~/ 1000));

      // Verify MD5 hash
      String expectedHashString = '$expires${Uri.parse(baselink).path} $secret';
      List<int> expectedBytes = utf8.encode(expectedHashString);
      Digest expectedDigest = md5.convert(expectedBytes);
      String expectedProtectionString = base64Url.encode(expectedDigest.bytes).replaceAll('=', '');
      expect(uri.queryParameters['md5'], expectedProtectionString);
    });
  });
}
