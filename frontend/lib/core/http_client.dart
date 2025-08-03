//## File: frontend/lib/core/http_client.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'services/token_storage.dart';

class HttpClient {
  final http.Client _client;
  final TokenStorage _tokenStorage;

  HttpClient(this._client, this._tokenStorage);

  Future<Map<String, String>> _getHeaders({bool requiresAuth = false}) async {
    final headers = Map<String, String>.from(ApiConfig.defaultHeaders);

    if (requiresAuth) {
      final token = await _tokenStorage.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<http.Response> get(
    String endpoint, {
    bool requiresAuth = false,
    Map<String, String>? queryParameters,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final uriWithQuery = queryParameters != null
        ? uri.replace(queryParameters: queryParameters)
        : uri;

    final headers = await _getHeaders(requiresAuth: requiresAuth);

    try {
      final response = await _client
          .get(uriWithQuery, headers: headers)
          .timeout(const Duration(seconds: 30));
      return response;
    } on SocketException {
      throw const HttpException('No internet connection');
    } on HttpException {
      throw const HttpException('Network error occurred');
    }
  }

  Future<http.Response> post(
    String endpoint, {
    required Map<String, dynamic> body,
    bool requiresAuth = false,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final headers = await _getHeaders(requiresAuth: requiresAuth);

    try {
      final response = await _client
          .post(
            uri,
            headers: headers,
            body: json.encode(body),
          )
          .timeout(const Duration(seconds: 30));
      return response;
    } on SocketException {
      throw const HttpException('No internet connection');
    } on HttpException {
      throw const HttpException('Network error occurred');
    }
  }

  Future<http.Response> put(
    String endpoint, {
    required Map<String, dynamic> body,
    bool requiresAuth = true,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final headers = await _getHeaders(requiresAuth: requiresAuth);

    try {
      final response = await _client
          .put(
            uri,
            headers: headers,
            body: json.encode(body),
          )
          .timeout(const Duration(seconds: 30));
      return response;
    } on SocketException {
      throw const HttpException('No internet connection');
    } on HttpException {
      throw const HttpException('Network error occurred');
    }
  }

  Future<http.Response> delete(
    String endpoint, {
    bool requiresAuth = true,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final headers = await _getHeaders(requiresAuth: requiresAuth);

    try {
      final response = await _client
          .delete(uri, headers: headers)
          .timeout(const Duration(seconds: 30));
      return response;
    } on SocketException {
      throw const HttpException('No internet connection');
    } on HttpException {
      throw const HttpException('Network error occurred');
    }
  }
}

class HttpException implements Exception {
  final String message;

  const HttpException(this.message);

  @override
  String toString() => 'HttpException: $message';
}
