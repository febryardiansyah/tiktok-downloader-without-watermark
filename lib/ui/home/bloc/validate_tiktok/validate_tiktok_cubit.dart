import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tiktok_downloader/models/tiktok_validation_model.dart';
import 'package:tiktok_downloader/services/api_services.dart';

part 'validate_tiktok_state.dart';

class ValidateTiktokCubit extends Cubit<ValidateTiktokState> {
  ValidateTiktokCubit(this.services) : super(ValidateTiktokInitial());
  final ApiServices services;

  void validate(String tiktokUrl) async {
    emit(ValidateTiktokLoading());
    try {
      final data = await services.validateTiktokUrl(tiktokUrl);
      data.videoUrl = tiktokUrl;
      emit(ValidateTiktokSuccess(data));
    } catch (e) {
      emit(ValidateTiktokFailure(e.toString()));
    }
  }
}
