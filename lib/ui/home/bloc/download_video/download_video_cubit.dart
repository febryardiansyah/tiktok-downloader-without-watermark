import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:tiktok_downloader/services/api_services.dart';

part 'download_video_state.dart';

class DownloadVideoCubit extends Cubit<DownloadVideoState> {
  DownloadVideoCubit(this.services) : super(DownloadVideoState());
  final ApiServices services;

  void download(String responseUrl) async {
    emit(DownloadVideoState());
    try {
      final checkPermission = await services.checkPermission();
      if (checkPermission) {
        var dir = Directory('/sdcard/download/');
        String fileName = '${DateTime.now().microsecondsSinceEpoch}.mp4';
        String filePath = "${dir.path}$fileName";
        await dio.download(
          responseUrl,
          filePath,
          onReceiveProgress: (rec, total) {
            emit(
              state.copyWith(
                isDownloading: true,
                progressString: ((rec / total) * 100).toStringAsFixed(0) + "%",
              ),
            );
          },
        );

        if (!await File(filePath).exists()) {
          emit(state.copyWith(err: 'File does not exist'));
          return;
        }
        emit(state.copyWith(
          isDownloading: false,
          progressString: "Completed",
          isDone: true,
          videoPath: filePath,
        ));

        // final open = await OpenFilex.open(filePath);
        // log("OPEN RESULT: ${open.message}",name: "Open File");
      } else {
        emit(state.copyWith(
          err: 'Make sure to allow the Permission',
        ));
      }
    } catch (e) {
      log("Error: $e", name: "DOWNLOAD");
      emit(state.copyWith(
        err: e.toString(),
      ));
    }
  }
}
