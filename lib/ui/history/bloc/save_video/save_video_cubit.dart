import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tiktok_downloader/models/tiktok_validation_model.dart';
import 'package:tiktok_downloader/services/db_service.dart';

part 'save_video_state.dart';

class SaveVideoCubit extends Cubit<SaveVideoState> {
  SaveVideoCubit(this.service) : super(SaveVideoInitial());
  final DbService service;

  void saveVideo(TiktokValidationModel video) async {
    emit(SaveVideoLoading());
    try {
      final msg = await service.saveVideo(video);

      emit(SaveVideoSuccess(msg));
    } catch (e) {
      emit(SaveVideoFailure(e.toString()));
    }
  }
}
