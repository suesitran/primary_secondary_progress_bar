import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:primary_secondary_progress_bar/primary_secondary_progress_bar.dart';

void main() {
  const MethodChannel channel = MethodChannel('primary_secondary_progress_bar');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
