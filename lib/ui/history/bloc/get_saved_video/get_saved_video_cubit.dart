import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tiktok_downloader/models/tiktok_validation_model.dart';
import 'package:tiktok_downloader/services/db_service.dart';

part 'get_saved_video_state.dart';

class GetSavedVideoCubit extends Cubit<GetSavedVideoState> {
  GetSavedVideoCubit(this.service) : super(GetSavedVideoInitial());
  final DbService service;

  void fetchData() async {
    emit(GetSavedVideoLoading());
    try {
      final data = await service.getSavedVideo();

      emit(GetSavedVideoSuccess(data));
    } catch (e) {
      emit(GetSavedVideoFailure(e.toString()));
    }
  }
}
