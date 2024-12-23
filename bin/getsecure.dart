import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:args/args.dart';

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

void main(List<String> arguments) {
  // Parse command line arguments
  final parser = ArgParser()
    ..addOption('period',
        abbr: 'p',
        defaultsTo: '30',
        help: 'Expiration period in days')
    ..addFlag('help',
        abbr: 'h',
        negatable: false,
        help: 'Show usage information');

  try {
    final results = parser.parse(arguments);

    if (results['help']) {
      print('Usage: getsecure_dart <baselink> <secret> [--period <days>]');
      print(parser.usage);
      exit(0);
    }

    if (results.rest.length != 2) {
      throw ArgParserException('Please provide baselink and secret');
    }

    final baselink = results.rest[0];
    final secret = results.rest[1];
    final period = int.parse(results['period']);

    final link = secureLink(baselink, secret, period: period);
    print(link);
    
  } on ArgParserException catch (e) {
    print('Error: ${e.message}');
    print('\nUsage: getsecure_dart <baselink> <secret> [--period <days>]');
    print(parser.usage);
    exit(1);
  }
}