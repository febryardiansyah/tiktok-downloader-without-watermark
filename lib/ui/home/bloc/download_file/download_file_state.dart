part of 'download_file_cubit.dart';

class DownloadFileState {
  final int progress;
  final DownloadTaskStatus downloadTaskStatus;
  final bool downloadStarted;
  final bool downloadDone;
  final String filePath;
  final String? err;

  const DownloadFileState({
    this.progress = 0,
    this.downloadTaskStatus = DownloadTaskStatus.undefined,
    this.downloadStarted = false,
    this.downloadDone = false,
    this.filePath = '',
    this.err,
  });

  DownloadFileState copyWith({
    int? progress,
    DownloadTaskStatus? downloadTaskStatus,
    bool? downloadStarted,
    bool? downloadDone,
    String? filePath,
    String? err,
  }) {
    return DownloadFileState(
      progress: progress ?? this.progress,
      downloadTaskStatus: downloadTaskStatus ?? this.downloadTaskStatus,
      downloadStarted: downloadStarted ?? this.downloadStarted,
      downloadDone: downloadDone ?? this.downloadDone,
      filePath: filePath ?? this.filePath,
      err: err ?? this.err,
    );
  }
}
