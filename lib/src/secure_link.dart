import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Creates a secure link with an expiration timestamp and MD5 hash protection
String secureLink(String baselink, String secret, {int period = 30}) {
  // Parse the URL
  Uri url = Uri.parse(baselink);
  
  // Calculate expiration timestamp
  DateTime now = DateTime.now();
  DateTime expirationDate = now.add(Duration(days: period));
  int expires = expirationDate.millisecondsSinceEpoch ~/ 1000;
  
  // Create hash string
  String hashstring = '$expires${url.path} $secret';
  
  // Generate MD5 hash
  List<int> bytes = utf8.encode(hashstring);
  Digest digest = md5.convert(bytes);
  
  // Convert to base64 with URL-safe characters
  String protectionString = base64Url.encode(digest.bytes).replaceAll('=', '');
  
  // Construct the protected link
  String protectedLink = '$baselink?md5=$protectionString&expires=$expires';
  
  return protectedLink;
} 