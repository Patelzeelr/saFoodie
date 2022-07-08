import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'url_factory.dart';

class BaseAPI {
  static Future<http.Response> apiPost<T>(
      {required T body,
      required String url,
      bool isHeaderIncluded = true}) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final headers = <String, String>{
      "Content-Type": "application/json",
    };
    if (isHeaderIncluded) {
      headers["token"] = _prefs.getString(token) ?? "";
    }
    try {
      final res = await http.post(Uri.parse(url), body: body, headers: headers);
      return res;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future apiGet<T>(
      {required String url, bool isHeaderIncluded = true}) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final headers = <String, String>{"Content-Type": "application/json"};
    if (isHeaderIncluded) {
      headers["token"] = _prefs.getString(token) ?? "";
    }
    final res = await http.get(Uri.parse(url), headers: headers);
    return res;
  }

  static Future<http.Response> apiPut<T>(
      {required T body,
      required String url,
      bool isHeaderIncluded = true}) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final headers = <String, String>{"Content-Type": "application/json"};
    if (isHeaderIncluded) {
      headers["token"] = _prefs.getString(token) ?? "";
    }
    final res = await http.put(Uri.parse(url), body: body, headers: headers);
    return res;
  }

  static Future<http.Response> apiDelete<T>(
      {required String url, bool isHeaderIncluded = true}) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final headers = <String, String>{
      "Content-Type": "application/json;charset=UTF-8"
    };
    if (isHeaderIncluded) {
      headers["token"] = _prefs.getString(token) ?? "";
    }
    final res = await http.delete(Uri.parse(url), headers: headers);
    return res;
  }
}
