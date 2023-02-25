part of 'download_video_cubit.dart';

class DownloadVideoState {
  final bool isDownloading;
  final String progressString;
  final bool isDone;
  final String videoPath;
  final String? err;

  DownloadVideoState({
    this.isDownloading = false,
    this.progressString = '',
    this.isDone = false,
    this.videoPath = '',
    this.err,
  });

  DownloadVideoState copyWith({
    bool? isDownloading,
    String? progressString,
    bool? isDone,
    String? videoPath,
    String? err,
  }) {
    return DownloadVideoState(
      isDownloading: isDownloading ?? this.isDownloading,
      progressString: progressString ?? this.progressString,
      isDone: isDone ?? this.isDone,
      videoPath: videoPath ?? this.videoPath,
      err: err ?? err,
    );
  }
}
