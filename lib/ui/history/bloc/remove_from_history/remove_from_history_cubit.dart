import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tiktok_downloader/services/db_service.dart';

part 'remove_from_history_state.dart';

class RemoveFromHistoryCubit extends Cubit<RemoveFromHistoryState> {
  RemoveFromHistoryCubit(this.service) : super(RemoveFromHistoryInitial());
  final DbService service;

  void remove(String videoPath) async {
    emit(RemoveFromHistoryLoading());
    try {
      await service.removeVideo(videoPath);
      emit(RemoveFromHistorySuccess("Video has been removed from history"));
    } catch (e) {
      emit(RemoveFromHistoryFailure(e.toString()));
    }
  }
}
