import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'ads_counter_state.dart';

class AdsCounterCubit extends Cubit<int> {
  AdsCounterCubit() : super(0);

  void increment() => emit(state + 1);
  void reset() => emit(0);
}
