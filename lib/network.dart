import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkHandler {
  NetworkHandler(this._url);
  String _url;
  Future getData() async {
    http.Response response = await http.get(_url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else
      print(response.statusCode);
  }
}
