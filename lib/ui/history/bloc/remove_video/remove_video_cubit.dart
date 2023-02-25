import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tiktok_downloader/services/db_service.dart';

part 'remove_video_state.dart';

class RemoveVideoCubit extends Cubit<RemoveVideoState> {
  RemoveVideoCubit(this.service) : super(RemoveVideoInitial());
  final DbService service;

  void removeVideo(String videoPath) async {
    emit(RemoveVideoLoading());
    try {
      final path = File(videoPath);
      if (!await path.exists()) {
        emit(RemoveVideoFailure("Video does not exist"));
        return;
      }
      await path.delete();
      await service.removeVideo(videoPath);
      emit(RemoveVideoSuccess("Video has been removed from file directory"));
    } catch (e) {
      emit(RemoveVideoFailure(e.toString()));
    }
  }
}
