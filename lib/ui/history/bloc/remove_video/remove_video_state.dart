part of 'remove_video_cubit.dart';

@immutable
abstract class RemoveVideoState {}

class RemoveVideoInitial extends RemoveVideoState {}
class RemoveVideoLoading extends RemoveVideoState {}
class RemoveVideoSuccess extends RemoveVideoState {
  final String msg;

  RemoveVideoSuccess(this.msg);
}
class RemoveVideoFailure extends RemoveVideoState {
  final String msg;

  RemoveVideoFailure(this.msg);
}
