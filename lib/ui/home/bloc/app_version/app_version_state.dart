part of 'app_version_cubit.dart';

abstract class AppVersionState {}

class AppVersionInitial extends AppVersionState {}
class AppVersionLoading extends AppVersionState {}
class AppVersionSuccess extends AppVersionState {
  final AppVersionModel data;

  AppVersionSuccess(this.data);
}
class AppVersionFailure extends AppVersionState {
  final String msg;

  AppVersionFailure(this.msg);
}
