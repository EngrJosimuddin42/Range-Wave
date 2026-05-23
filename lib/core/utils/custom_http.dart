import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:range_wave/core/app_credentials.dart';
import 'package:range_wave/core/utils/app_helper.dart';
import 'package:range_wave/core/utils/custom_toast.dart';
import 'package:range_wave/core/utils/has_internet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomHttpResult {
  final dynamic data;
  final int statusCode;
  final String? error;

  const CustomHttpResult({this.data, required this.statusCode, this.error});
}

enum CommonCustomMethods { POST, PUT, PATCH, DELETE }

class CustomHttp {
  // ─────────────────────────────────────────────
  //  GET
  // ─────────────────────────────────────────────
  static Future<CustomHttpResult> get({
    required String endpoint,
    bool showFloatingError = true,
    bool needAuth = false,
    Map<String, String>? headers,
    Map<String, dynamic>? queries,
  }) async {
    if (!await hasInternet(showError: true)) {
      return const CustomHttpResult(
        statusCode: -1,
        error: 'No Internet! Please check your internet connection.',
      );
    }

    try {
      final Map<String, String> _headers = {'Content-Type': 'application/json','ngrok-skip-browser-warning': 'true'};

      if (needAuth) {
        final authResult = await _attachAuth(_headers);
        if (!authResult) {
          return const CustomHttpResult(
            statusCode: 401,
            error: 'Session expired, Please sign in again!',
          );
        }
      }

      if (headers != null) _headers.addAll(headers);

      var url = '${AppCredentials.domain}/$endpoint';

      if (queries != null) {
        url += '?';
        queries.forEach((key, value) {
          if (value is List) {
            for (var item in value) {
              url += '$key=$item&';
            }
          } else {
            url += '$key=$value&';
          }
        });
        url = url.substring(0, url.length - 1);
      }

      final uri = Uri.parse(url);

      debugPrint('');
      debugPrint('<===== GET REQUEST =====>');
      debugPrint('url: $url');
      debugPrint('headers: $_headers');
      debugPrint('');

      final response = await http.get(uri, headers: _headers);
      return _handleResponse(response, showFloatingError);
    } catch (e) {
      debugPrint('<===== GET REQUEST ERROR =====>');
      debugPrint('url: $endpoint');
      debugPrint('error: $e');
      return CustomHttpResult(statusCode: -2, error: e.toString());
    }
  }

  //  POST / PUT / PATCH / DELETE (convenience)

  static Future<CustomHttpResult> post({
    required String endpoint,
    Map<String, String>? headers,
    dynamic body,
    bool showFloatingError = true,
    bool needAuth = true,
  }) => _commonRequests(
    endpoint: endpoint,
    headers: headers,
    body: body,
    showFloatingError: showFloatingError,
    needAuth: needAuth,
    method: CommonCustomMethods.POST,
  );

  static Future<CustomHttpResult> put({
    required String endpoint,
    Map<String, String>? headers,
    dynamic body,
    bool showFloatingError = true,
    bool needAuth = true,
  }) => _commonRequests(
    endpoint: endpoint,
    headers: headers,
    body: body,
    showFloatingError: showFloatingError,
    needAuth: needAuth,
    method: CommonCustomMethods.PUT,
  );

  static Future<CustomHttpResult> patch({
    required String endpoint,
    Map<String, String>? headers,
    dynamic body,
    bool showFloatingError = true,
    bool needAuth = true,
  }) => _commonRequests(
    endpoint: endpoint,
    headers: headers,
    body: body,
    showFloatingError: showFloatingError,
    needAuth: needAuth,
    method: CommonCustomMethods.PATCH,
  );

  static Future<CustomHttpResult> delete({
    required String endpoint,
    Map<String, String>? headers,
    dynamic body,
    bool showFloatingError = true,
    bool needAuth = true,
  }) => _commonRequests(
    endpoint: endpoint,
    headers: headers,
    body: body,
    showFloatingError: showFloatingError,
    needAuth: needAuth,
    method: CommonCustomMethods.DELETE,
  );


  //  MULTIPART

  static Future<CustomHttpResult> multipart({
    required String endpoint,
    required CommonCustomMethods method,
    Map<String, String>? headers,
    Map<String, String> fields = const {},
    List<http.MultipartFile> files = const [],
  }) async {
    final url = '${AppCredentials.domain}/$endpoint';
    final uri = Uri.parse(url);

    final token = await AppHelper.instance.getAccessToken();

    final request = http.MultipartRequest(method.name, uri);
    final Map<String, String> _headers = {
      'Authorization': 'Bearer $token',
      'ngrok-skip-browser-warning': 'true',
      ...?headers,
    };

    request.headers.addAll(_headers);
    fields.forEach((key, value) => request.fields[key] = value);
    for (final file in files) {
      request.files.add(file);
    }

    debugPrint('');
    debugPrint('<===== ${method.name} MULTIPART REQUEST =====>');
    debugPrint('url: $url');
    debugPrint('');

    try {
      final streamed = await request.send();
      final body = await streamed.stream.bytesToString();

      if (streamed.statusCode == 200 || streamed.statusCode == 201) {
        return CustomHttpResult(
          statusCode: streamed.statusCode,
          data: jsonDecode(body),
        );
      } else {
        return CustomHttpResult(statusCode: streamed.statusCode, error: body);
      }
    } catch (e) {
      debugPrint('<===== MULTIPART REQUEST ERROR =====>');
      debugPrint('url: $endpoint');
      debugPrint('error: $e');
      return CustomHttpResult(statusCode: -2, error: e.toString());
    }
  }


  //  CORE

  static Future<CustomHttpResult> _commonRequests({
    required String endpoint,
    Map<String, String>? headers,
    dynamic body,
    bool showFloatingError = true,
    bool needAuth = true,
    required CommonCustomMethods method,
    bool retry = true,
  }) async {
    if (!await hasInternet(showError: true)) {
      return const CustomHttpResult(
        statusCode: -1,
        error: 'No Internet! Please check your internet connection.',
      );
    }

    try {
      final Map<String, String> _headers = {'Content-Type': 'application/json','ngrok-skip-browser-warning': 'true'};

      final localStorage = await SharedPreferences.getInstance();

      if (needAuth) {
        final authResult = await _attachAuth(_headers);
        if (!authResult) {
          return const CustomHttpResult(
            statusCode: 401,
            error: 'Session expired, Please sign in again!',
          );
        }
      }

      if (headers != null) _headers.addAll(headers);

      final url = '${AppCredentials.domain}/$endpoint';
      final uri = Uri.parse(url);
      final encodedBody = jsonEncode(body ?? {});

      debugPrint('');
      debugPrint('<===== ${method.name} REQUEST =====>');
      debugPrint('url: $url');
      debugPrint('headers: $_headers');
      debugPrint('body: $encodedBody');
      debugPrint('');

      http.Response response;

      switch (method) {
        case CommonCustomMethods.POST:
          response = await http.post(
            uri,
            body: encodedBody,
            headers: _headers,
            encoding: Encoding.getByName('utf-8'),
          );
          break;
        case CommonCustomMethods.PUT:
          response = await http.put(
            uri,
            body: encodedBody,
            headers: _headers,
            encoding: Encoding.getByName('utf-8'),
          );
          break;
        case CommonCustomMethods.PATCH:
          response = await http.patch(
            uri,
            body: encodedBody,
            headers: _headers,
            encoding: Encoding.getByName('utf-8'),
          );
          break;
        case CommonCustomMethods.DELETE:
          response = await http.delete(
            uri,
            body: encodedBody,
            headers: _headers,
            encoding: Encoding.getByName('utf-8'),
          );
          break;
      }

      // Save cookie if present
      final setCookie = response.headers['set-cookie'];
      if (setCookie != null) {
        localStorage.setString('cookie', setCookie);
      }

      // Auto-refresh & retry once on 401
      if (response.statusCode == 401 && retry) {
        final refreshed = await _refreshToken();
        if (refreshed) {
          return _commonRequests(
            endpoint: endpoint,
            headers: headers,
            body: body,
            showFloatingError: showFloatingError,
            needAuth: needAuth,
            method: method,
            retry: false,
          );
        } else {
          return const CustomHttpResult(
            statusCode: 401,
            error: 'Session expired, Please sign in again!',
          );
        }
      }

      return _handleResponse(response, showFloatingError);
    } catch (e) {
      debugPrint('<===== ${method.name} REQUEST ERROR =====>');
      debugPrint('url: $endpoint');
      debugPrint('error: $e');
      return CustomHttpResult(statusCode: -2, error: e.toString());
    }
  }


  //  AUTH HELPERS─

  /// Attaches Authorization + Cookie headers.
  /// Returns false if the token could not be refreshed.
  static Future<bool> _attachAuth(Map<String, String> headers) async {
    final localStorage = await SharedPreferences.getInstance();

    // getInt + compare in SECONDS (JWT exp is Unix seconds)
    final int? validTill = localStorage.getInt('access_token_valid_till');
    final int nowSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    if (validTill == null || validTill < nowSeconds) {
      final refreshed = await _refreshToken();
      if (!refreshed) return false;
    }

    final accessToken = localStorage.getString('access_token');
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    final cookie = localStorage.getString('cookie');
    if (cookie != null) {
      headers['Cookie'] = cookie;
    }

    return true;
  }


  static Future<bool> _refreshToken() async {
    final localStorage = await SharedPreferences.getInstance();
    final refreshToken = await AppHelper.instance.getRefToken();
    final userId = await AppHelper.instance.getUserId();

    if (refreshToken == null || userId == null) {
      // Don't clear if we're just missing it (user not logged in yet)
      return false;
    }

    try {
      final response = await http.get(
        Uri.parse('${AppCredentials.domain}/auth/new-token'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refreshToken',
        },
      );

      debugPrint('<===== REFRESH TOKEN =====>');
      debugPrint('Status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        // setString for token, setInt for expiry (seconds)
        await AppHelper.instance.setAccessToken(data['access_token']);
        await AppHelper.instance.setTokenValidity(
          data['access_token_valid_till'] as int,
        );
        return true;
      } else {
        debugPrint('Refresh failed: ${response.body}');
        await localStorage.clear();
        return false;
      }
    } catch (e) {
      debugPrint('Refresh error: $e');
      await localStorage.clear();
      return false;
    }
  }

  // ─────────────────────────────────────────────
  //  RESPONSE HANDLER
  // ─────────────────────────────────────────────
  static CustomHttpResult _handleResponse(
    http.Response response,
    bool showFloatingError,
  ) {
    debugPrint('<===== RESPONSE =====>');
    debugPrint('Status: ${response.statusCode}');

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      dynamic data;
      try {
        data = response.body.isNotEmpty ? jsonDecode(response.body) : null;
      } catch (_) {
        data = null;
      }
      return CustomHttpResult(statusCode: response.statusCode, data: data);
    }

    // Error path
    String message;
    try {
      final body = jsonDecode(response.body);
      // Try common error shapes
      if (body is Map) {
        message =
            body['errors']?[0] ??
            body['message'] ??
            body['detail'] ??
            response.body;
      } else {
        message = response.body;
      }
    } catch (_) {
      message = response.body.isNotEmpty
          ? response.body
          : 'Something went wrong';
    }

    if (showFloatingError) {
      showCustomToast(text: message);
    }

    return CustomHttpResult(statusCode: response.statusCode, error: message);
  }
}
