import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tiktok_downloader/services/api_services.dart';

part 'get_data_state.dart';

class GetDataCubit extends Cubit<GetDataState> {
  GetDataCubit(this.services) : super(GetDataInitial());
  final ApiServices services;

  void fetchData(String tiktokUrl) async {
    emit(GetDataLoading());
    try {
      final url = await services.getData(tiktokUrl);

      emit(GetDataSuccess(url));
    } catch (e) {
      emit(GetDataFailure(e.toString()));
    }
  }
}
