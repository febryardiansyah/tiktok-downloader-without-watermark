part of 'validate_tiktok_cubit.dart';

@immutable
abstract class ValidateTiktokState {}

class ValidateTiktokInitial extends ValidateTiktokState {}
class ValidateTiktokLoading extends ValidateTiktokState {}
class ValidateTiktokSuccess extends ValidateTiktokState {
  final TiktokValidationModel data;

  ValidateTiktokSuccess(this.data);
}
class ValidateTiktokFailure extends ValidateTiktokState {
  final String msg;

  ValidateTiktokFailure(this.msg);
}
