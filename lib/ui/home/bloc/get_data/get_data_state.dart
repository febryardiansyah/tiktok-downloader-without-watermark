part of 'get_data_cubit.dart';

@immutable
abstract class GetDataState {}

class GetDataInitial extends GetDataState {}
class GetDataLoading extends GetDataState {}
class GetDataSuccess extends GetDataState {
  final String url;

  GetDataSuccess(this.url);
}
class GetDataFailure extends GetDataState {
  final String msg;

  GetDataFailure(this.msg);
}
