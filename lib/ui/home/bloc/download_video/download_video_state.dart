part of 'download_video_cubit.dart';

class DownloadVideoState {
  final bool isDownloading;
  final String progressString;
  final String? err;

  DownloadVideoState({
    this.isDownloading = false,
    this.progressString = '',
    this.err,
  });

  DownloadVideoState copyWith({
    bool? isDownloading,
    String? progressString,
    String? err,
  }) {
    return DownloadVideoState(
      isDownloading: isDownloading ?? this.isDownloading,
      progressString: progressString ?? this.progressString,
      err: err ?? err,
    );
  }
}
