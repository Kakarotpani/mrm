import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';

class HttpServices {
  Future getService() async {
    const String api = 'https://random-data-api.com/api/v2/beers?size=10&response_type=json';
    try {
      Response response = await get(Uri.parse(api));
      switch (response.statusCode) {
        case 200:
          final data = json.decode(response.body);
          return data;
        default:
          throw Exception(response.reasonPhrase);
      }
    } on SocketException catch (_) {
      rethrow;
    }
  }
}

