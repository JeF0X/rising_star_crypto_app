import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpService {
  Future<dynamic> sendRequest(String url) async {
    http.Response response = await http.get(Uri.parse(url));
    log('Request URL: $url');
    log('Response status: ${response.statusCode}');
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      var jsonBody = json.decode(response.body);
      return jsonBody;
    } else {
      throw HttpException('Problem loading data', uri: Uri.parse(url));
    }
  }
}
