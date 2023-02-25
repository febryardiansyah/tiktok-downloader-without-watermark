part of 'get_saved_video_cubit.dart';

@immutable
abstract class GetSavedVideoState {}

class GetSavedVideoInitial extends GetSavedVideoState {}
class GetSavedVideoLoading extends GetSavedVideoState {}
class GetSavedVideoSuccess extends GetSavedVideoState {
  final List<TiktokValidationModel> data;

  GetSavedVideoSuccess(this.data);
}
class GetSavedVideoFailure extends GetSavedVideoState {
  final String msg;

  GetSavedVideoFailure(this.msg);
}
