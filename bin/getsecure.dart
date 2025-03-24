import 'package:args/args.dart';
import 'package:getsecure/getsecure.dart';
import 'dart:io';

void main(List<String> arguments) {
  // Parse command line arguments
  final parser = ArgParser()
    ..addOption('period',
        abbr: 'p', defaultsTo: '30', help: 'Expiration period in days')
    ..addFlag('help',
        abbr: 'h', negatable: false, help: 'Show usage information');

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
