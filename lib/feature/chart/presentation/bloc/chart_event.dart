part of 'chart_bloc.dart';

@immutable
sealed class ChartEvent {}

class ChartRebuildFromItems extends ChartEvent {
  ChartRebuildFromItems(this.items);
  final List<UserItemEntity> items;
}
