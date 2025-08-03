// # File: frontend/lib/core/services/api_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'token_storage.dart';
import '../../config/api_config.dart';
import '../error/exceptions.dart';

abstract class ApiService {
  Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, String>? queryParams});
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data);
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data);
  Future<Map<String, dynamic>> delete(String endpoint);
}

class ApiServiceImpl implements ApiService {
  final http.Client client;
  final TokenStorage tokenStorage;
  final Connectivity connectivity;

  ApiServiceImpl({
    required this.client,
    required this.tokenStorage,
    required this.connectivity,
  });

  Future<Map<String, String>> _getHeaders({bool requiresAuth = false}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = await tokenStorage.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw NetworkException('No internet connection');
    }
  }

  @override
  Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, String>? queryParams}) async {
    try {
      await _checkConnectivity();

      var uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final headers = await _getHeaders(requiresAuth: true);
      final response = await client.get(uri, headers: headers);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('Network error occurred');
    } catch (e) {
      if (e is NetworkException || e is ServerException) rethrow;
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> data) async {
    try {
      await _checkConnectivity();

      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers = await _getHeaders(requiresAuth: true);

      final response = await client.post(
        uri,
        headers: headers,
        body: json.encode(data),
      );

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('Network error occurred');
    } catch (e) {
      if (e is NetworkException || e is ServerException) rethrow;
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> put(
      String endpoint, Map<String, dynamic> data) async {
    try {
      await _checkConnectivity();

      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers = await _getHeaders(requiresAuth: true);

      final response = await client.put(
        uri,
        headers: headers,
        body: json.encode(data),
      );

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('Network error occurred');
    } catch (e) {
      if (e is NetworkException || e is ServerException) rethrow;
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      await _checkConnectivity();

      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers = await _getHeaders(requiresAuth: true);

      final response = await client.delete(uri, headers: headers);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('Network error occurred');
    } catch (e) {
      if (e is NetworkException || e is ServerException) rethrow;
      throw ServerException('Unexpected error: $e');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else {
          return {'data': decoded};
        }
      } catch (e) {
        return {'message': 'Success', 'data': response.body};
      }
    } else if (response.statusCode == 401) {
      throw AuthenticationException('Authentication failed');
    } else if (response.statusCode == 404) {
      throw ServerException('Resource not found');
    } else {
      throw ServerException('Server error: ${response.statusCode}');
    }
  }
}
