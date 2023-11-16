import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../constants/endpoints.dart';
import '../../utilities/app_exception.dart';

/// This class handles all network logic only and will not be called
/// anywhere except in the Repository class
class NetworkService {
  static final instance = NetworkService._();
  NetworkService._();

  final _endpoints = Endpoints.instance;

  // I will always send the notification to myself but I made the key receivable
  // to make the class responsible of network logic only and in case if it is a
  // real application i can use to send to anyine other than myself

  // If the business needs to send notifications to multiple tokens I will just
  // make token a list of strings
  Future<void> sendNotification({
    required String token,
    required String title,
    required String body,
  }) async {
    await _post(
      _endpoints.sendNotification,
      body: {
        'registration_ids': [token],
        'collapse_key': 'type_a',
        'notification': {'title': title, 'body': body},
      },
    );
  }

  Future<String> _post(String url, {Map<String, Object>? body}) async {
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader:
                  'key=AAAAM74lcRs:APA91bFVyQ-wMuM0nVTcD9ngsET04hYUGYd97-OSrtlGHg3wGBJs0FNfWF7eJ1yWchmI0k86dw6evP2kSxwGbX5vFrFBEQXYuhL_7FvAqJ9oHvQJc-r59Fx1D9YNNrq1SSfnvHyFMNnF',
            },
            body: json.encode(body),
          )
          .timeout(const Duration(minutes: 1));
      return _processResponse(response);
    } catch (e) {
      throw _getExceptionString(e as Exception);
    }
  }

  String _getExceptionString(Exception error) {
    if (error is SocketException) {
      return 'There is no internet connection';
    }
    if (error is HttpException) {
      return 'An error occurred in the request';
    }
    if (error is FormatException) {
      return 'Invalid data format';
    }
    if (error is TimeoutException) {
      return 'request timeout, please try again';
    }
    if (error is AppException) {
      return error.message;
    }
    return 'Unknown error occured';
  }

  String _processResponse(http.Response response) {
    switch (response.statusCode) {
      case HttpStatus.ok:
        return response.body;

      case HttpStatus.created:
        return response.body;

      case HttpStatus.badRequest:
        throw BadRequestException(
          json.decode(response.body)['message'],
          response.request!.url.toString(),
        );

      case HttpStatus.unauthorized:
        throw UnauthorizedException(
          json.decode(response.body)['message'],
          response.request!.url.toString(),
        );

      case HttpStatus.forbidden:
        throw UnauthorizedException(
          json.decode(response.body)['message'],
          response.request!.url.toString(),
        );

      case HttpStatus.notFound:
        throw NotFoundException(
          json.decode(response.body)['message'],
          response.request!.url.toString(),
        );

      default:
        throw FetchDataException(
          json.decode(response.body)['message'],
          response.request!.url.toString(),
        );
    }
  }
}
