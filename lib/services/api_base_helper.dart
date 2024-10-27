import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sonomaneoutlet/common/alert.dart';
import 'handle_exception.dart';

class ApiBaseHelper {
  Future<dynamic> post(String url, Map body, dynamic context) async {
    debugPrint('Api Post, url $url');
    Notifikasi.loading(context);
    var responseJson;
    try {
      final response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body));

      debugPrint(response.body);
      responseJson = _returnResponse(response, context);
    } on SocketException {
      Navigator.of(context, rootNavigator: true).pop();
      throw FetchDataException('Tidak ada koneksi internet..');
    }
    Navigator.of(context, rootNavigator: true).pop();
    return responseJson;
  }
}

dynamic _returnResponse(http.Response response, dynamic context) {
  switch (response.statusCode) {
    case 200:
      return {"status_code": 200, "data": json.decode(response.body)};
    case 201:
      return {"status_code": 201, "data": json.decode(response.body)};
    case 202:
      return response;
    case 400:
      Navigator.of(context, rootNavigator: true).pop();
      throw BadRequestException("Ada kesalahan harap coba lagi nanti.");
    case 401:
    case 403:
      Navigator.of(context, rootNavigator: true).pop();
      throw UnauthorisedException(
          "User tidak dikenali, pastikan anda telah login.");
    case 500:
      Navigator.of(context, rootNavigator: true).pop();
      throw ServerErrorException("Gagal terhubung dengan server.");
    default:
      Navigator.of(context, rootNavigator: true).pop();
      throw FetchDataException(
          'Gagal terhubung dengan server dengan Status Code : ${response.statusCode}');
  }
}
