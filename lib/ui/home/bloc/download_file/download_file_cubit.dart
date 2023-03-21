import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:open_filex/open_filex.dart';
import 'package:tiktok_downloader/services/api_services.dart';

part 'download_file_state.dart';

class DownloadFileCubit extends Cubit<DownloadFileState> {
  DownloadFileCubit(this.service) : super(DownloadFileState());
  ApiServices service;

  late ReceivePort _port;

  void resetState() => emit(DownloadFileState());

  void registerPort() {
    _port = ReceivePort();
    IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    _port.listen((dynamic data) {
      print('LISTENING PORT: $data');
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      log('$progress', name: 'PEROGRESS');
      // emit(state.copyWith(
      //   progress: progress,
      //   downloadTaskStatus: status,
      //   downloadStarted: status == DownloadTaskStatus.running,
      //   downloadDone: status == DownloadTaskStatus.complete,
      // ));
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  void startDownload(String responseUrl) async {
    emit(const DownloadFileState());
    Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(
      downloadStarted: true,
    ));
    try {
      String? filePath = await service.downloadFile(responseUrl);
      emit(state.copyWith(
        filePath: filePath,
        downloadDone: true,
        downloadStarted: false,
      ));
      registerPort();
    } catch (e) {
      emit(
        state.copyWith(err: e.toString()),
      );
    }
  }

  void openFile() async {
    final result = await OpenFilex.open(state.filePath);
    log('${result.type}/n${state.filePath}', name: 'OPEN_FILE_RESULT_TYPE');
  }

  void resetPort() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    _port.close();
  }

  @override
  Future<void> close() {
    resetPort();
    return super.close();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
    String id,
    DownloadTaskStatus status,
    int progress,
  ) {
    final SendPort? send = IsolateNameServer.lookupPortByName(
      'downloader_send_port',
    );
    send?.send([id, status, progress]);
  }
}
