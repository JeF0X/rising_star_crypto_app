import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'http_service_test.mocks.dart';

@GenerateMocks([http.Client])
main() {
  test('valid json string', () {});
}
