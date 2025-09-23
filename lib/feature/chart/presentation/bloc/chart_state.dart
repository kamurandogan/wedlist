part of 'chart_bloc.dart';

@immutable
sealed class ChartState {}

class ChartInitial extends ChartState {}

class ChartEmpty extends ChartState {}

class ChartLoaded extends ChartState {
  ChartLoaded(this.items);
  final List<CategorySpending> items;
}
