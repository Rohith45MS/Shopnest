import 'package:dio/dio.dart';
import '../core/constants/api_constants.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/user_model.dart';

class ApiService {
  static ApiService? _instance;
  late Dio _dio;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print(' ${options.method} ${options.uri}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          print(' ${response.statusCode} ${response.requestOptions.uri}');
          handler.next(response);
        },
        onError: (DioException e, handler) {
          print(' Error: ${e.message}');
          handler.next(e);
        },
      ),
    );
  }

  static ApiService get instance {
    _instance ??= ApiService._internal();
    return _instance!;
  }

  Future<List<ProductModel>> getProducts({
    int offset = 0,
    int limit = ApiConstants.defaultLimit,
    int? categoryId,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'offset': offset,
        'limit': limit,
      };
      if (categoryId != null) {
        queryParams['categoryId'] = categoryId;
      }

      final response = await _dio.get(
        ApiConstants.productsEndpoint,
        queryParameters: queryParams,
      );

      final List<dynamic> data = response.data;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await _dio.get('${ApiConstants.productsEndpoint}/$id');
      return ProductModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dio.get(ApiConstants.categoriesEndpoint);
      final List<dynamic> data = response.data;
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<UserModel>> getUsers({int limit = 20}) async {
    try {
      final response = await _dio.get(
        ApiConstants.usersEndpoint,
        queryParameters: {'limit': limit},
      );
      final List<dynamic> data = response.data;
      return data.map((json) => UserModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return Exception('Connection timeout. Please check your internet.');
      case DioExceptionType.connectionError:
        return Exception('No internet connection.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        return Exception('Server error: $statusCode');
      default:
        return Exception(e.message ?? 'An unexpected error occurred.');
    }
  }
}
