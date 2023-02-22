import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:tiktok_downloader/models/app_version_model.dart';
import 'package:tiktok_downloader/services/firebase_service.dart';

part 'app_version_state.dart';

class AppVersionCubit extends Cubit<AppVersionState> {
  AppVersionCubit(this.service) : super(AppVersionInitial());

  final FirebaseService service;

  void checkVersion() async {
    emit(AppVersionInitial());
    try {
      final data = await service.getRemoteConfig();
      print('APP VERSION CONFIG: ${data.getValue('tiktok_downloader').asString()}');
      final parsed = AppVersionModel.fromMap(
        json.decode(data.getValue('tiktok_downloader').asString()),
      );
      emit(AppVersionSuccess(parsed));
    } catch (e) {
      print('Get App version config err: $e');
      emit(AppVersionFailure(e.toString()));
    }
  }
}
