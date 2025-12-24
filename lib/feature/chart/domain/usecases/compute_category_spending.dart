import 'package:wedlist/core/entities/user_item_entity.dart';
import 'package:wedlist/feature/chart/domain/entities/category_spending.dart';

class ComputeCategorySpending {
  const ComputeCategorySpending();

  List<CategorySpending> call(List<UserItemEntity> items) {
    final map = <String, _Agg>{};
    for (final it in items) {
      final key = it.category.trim();
      final curr = map[key] ?? const _Agg(0, 0);
      map[key] = _Agg(
        curr.total + (it.price.isNaN ? 0.0 : it.price),
        curr.count + 1,
      );
    }
    return map.entries
        .map(
          (e) => CategorySpending(
            category: e.key,
            total: e.value.total,
            count: e.value.count,
          ),
        )
        .toList()
      ..sort((a, b) => b.total.compareTo(a.total));
  }
}

class _Agg {
  const _Agg(this.total, this.count);
  final double total;
  final int count;
}
