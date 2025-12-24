import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedlist/core/entities/user_item_entity.dart';
import 'package:wedlist/feature/chart/domain/entities/category_spending.dart';
import 'package:wedlist/feature/chart/domain/usecases/compute_category_spending.dart';

part 'chart_event.dart';
part 'chart_state.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  ChartBloc(this._compute) : super(ChartInitial()) {
    on<ChartRebuildFromItems>(_onRebuild);
  }

  final ComputeCategorySpending _compute;

  Future<void> _onRebuild(
    ChartRebuildFromItems event,
    Emitter<ChartState> emit,
  ) async {
    final data = _compute(event.items);
    if (data.isEmpty) {
      emit(ChartEmpty());
    } else {
      emit(ChartLoaded(data));
    }
  }
}
