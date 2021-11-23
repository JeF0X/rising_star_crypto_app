import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpService {
  static const int statusOk = 200;

  Future<Map<String, dynamic>?> sendRequest(String url) async {
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == statusOk) {
      log('Request URL: $url');
      log('Response status: ${response.statusCode}');
      var jsonBody = json.decode(response.body);
      return jsonBody;
    } else {
      // TODO: Handle exceptions
      throw Exception('Could not load data');
    }
  }
}
