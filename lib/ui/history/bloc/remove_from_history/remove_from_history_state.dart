part of 'remove_from_history_cubit.dart';

@immutable
abstract class RemoveFromHistoryState {}

class RemoveFromHistoryInitial extends RemoveFromHistoryState {}
class RemoveFromHistoryLoading extends RemoveFromHistoryState {}
class RemoveFromHistorySuccess extends RemoveFromHistoryState {
  final String msg;

  RemoveFromHistorySuccess(this.msg);
}
class RemoveFromHistoryFailure extends RemoveFromHistoryState {
  final String msg;

  RemoveFromHistoryFailure(this.msg);
}
