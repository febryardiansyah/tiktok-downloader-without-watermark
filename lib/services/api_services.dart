import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_downloader/models/tiktok_validation_model.dart';
import 'package:tiktok_downloader/utils/utils.dart';

final dio = Dio();

class ApiServices {
  Future<String> getData(String tiktokUrl) async {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        log('REQUEST: ${options.path}');
        return handler.next(options);
      },
      onError: (e, handler) {
        log('ERROR: ${e.message}');
        log('ERROR STATUS CODE: ${e.response?.statusCode}');
        log(
          'ERROR DATA: ${e.response?.data}',
        );
        final response = e.response;
        if (e.error is SocketException ||
            e.type == DioErrorType.connectTimeout ||
            e.type == DioErrorType.receiveTimeout) {
          throw BaseString.errorNoInternet;
        } else if (response != null) {
          if (response.statusCode != null) {
            if (response.statusCode == 502) {
              throw BaseString.serverError;
            }
          }
          throw response.data['message'];
        }
        return handler.reject(e);
      },
      onResponse: (response, handler) {
        log('SUCCESS ${response.data}');
        handler.resolve(response);
      },
    ));
    try {
      final res = await dio.post(BaseString.downloadUrl, data: {
        'url': tiktokUrl,
      });
      return res.data['data']['no_wm'];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkPermission() async {
    final permissionStatus = await Permission.manageExternalStorage.request();
    if (permissionStatus.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  Future<TiktokValidationModel> validateTiktokUrl(String tiktokUrl) async {
    try {
      final res = await dio.get(
        "https://www.tiktok.com/oembed",
        queryParameters: {
          "url": tiktokUrl,
        },
      );

      return TiktokValidationModel.fromJson(res.data);
    } catch (e) {
      rethrow;
    }
  }
}
