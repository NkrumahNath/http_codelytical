import 'dart:async';
import 'dart:io';
import 'package:http_codelytical/src/enums/appEnums.dart';
import 'package:http/http.dart' as client;
import 'package:http_codelytical/src/httpManager/apiConfig.dart';
import 'package:http_codelytical/src/httpManager/headers.dart';
import 'package:http_codelytical/src/httpManager/responseHandler.dart';
import 'package:http_codelytical/src/requestResponse/requestResponse.dart';
// import 'package:logger/logger.dart';

// var logger = Logger(
//   printer: PrettyPrinter(),
// );

class HttpManager {
  static Future<Object> request(String url, {
    required HttpReqType type,
    String? body,
    bool includeToken = false,
    bool includeApiKey = false,
  }) async {
    final completeUrl = ApiConfig.getBaseUrl() + url;
    print('[HttpManager] Making request to: $completeUrl');
    print('[HttpManager] Making request to: $url');
    try {
      client.Response response;
      switch (type) {
        case HttpReqType.get:
          response = await client
              .get(
              Uri.parse(completeUrl),
              headers: Headers.getHeader(
                  includeToken: includeToken, includeApiKey: includeApiKey)
          )
              .timeout(Duration(seconds: ApiConfig.requestTimedOut));
          break;
        case HttpReqType.post:
          response = await client
              .post(
            Uri.parse(completeUrl),
            headers: Headers.getHeader(
                includeToken: includeToken, includeApiKey: includeApiKey),
            body: body,
          )
              .timeout(Duration(seconds: ApiConfig.requestTimedOut));
          break;
        case HttpReqType.put:
          response = await client
              .put(
            Uri.parse(completeUrl),
            headers: Headers.getHeader(
                includeToken: includeToken, includeApiKey: includeApiKey),
            body: body,
          )
              .timeout(Duration(seconds: ApiConfig.requestTimedOut));
          break;
        case HttpReqType.delete:
          response = await client
              .delete(
            Uri.parse(completeUrl),
            headers: Headers.getHeader(
                includeToken: includeToken, includeApiKey: includeApiKey),
            body: body,
          )
              .timeout(Duration(seconds: ApiConfig.requestTimedOut));
          break;
        case HttpReqType.patch:
          response = await client
              .patch(
            Uri.parse(completeUrl),
            headers: Headers.getHeader(
                includeToken: includeToken, includeApiKey: includeApiKey),
            body: body,
          )
              .timeout(Duration(seconds: ApiConfig.requestTimedOut));
          break;
      }
      return responseHandler(response);
    } on HttpException {
      print("Failed to make HTTP request: HttpException");
      return FailedResponse.failedNetwork;
    } on SocketException {
      print("Failed to make HTTP request: SocketException");
      return FailedResponse.failedNetwork;
    } on FormatException {
      print("Failed to make HTTP request: FormatException");
      return FailedResponse.invalidFormatError;
    } on TimeoutException {
      print("HTTP request timed out");
      return FailedResponse.timedOutError;
    } catch (e) {
      print("Error during HTTP request: ${e.toString()}");
      return FailedResponse.unknownError;
    }
  }
}