part of 'save_video_cubit.dart';

@immutable
abstract class SaveVideoState {}

class SaveVideoInitial extends SaveVideoState {}
class SaveVideoLoading extends SaveVideoState {}
class SaveVideoSuccess extends SaveVideoState {
  final String msg;

  SaveVideoSuccess(this.msg);
}
class SaveVideoFailure extends SaveVideoState {
  final String msg;

  SaveVideoFailure(this.msg);
}
