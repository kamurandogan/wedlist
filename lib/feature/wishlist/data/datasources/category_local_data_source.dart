import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedlist/feature/wishlist/data/models/category_item_model.dart';

abstract class CategoryLocalDataSource {
  Future<List<CategoryItemModel>> getCachedCategories();
  Future<void> cacheCategories(List<CategoryItemModel> categories);
  Future<void> clearCache();
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  CategoryLocalDataSourceImpl(this.prefs);
  final SharedPreferences prefs;

  static const String _cachedCategoriesKey = 'cached_categories';

  @override
  Future<List<CategoryItemModel>> getCachedCategories() async {
    final jsonString = prefs.getString(_cachedCategoriesKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList
          .map(
            (item) => CategoryItemModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> cacheCategories(List<CategoryItemModel> categories) async {
    final jsonList = categories.map((category) {
      return {'title': category.title};
    }).toList();

    final jsonString = json.encode(jsonList);
    await prefs.setString(_cachedCategoriesKey, jsonString);
  }

  @override
  Future<void> clearCache() async {
    await prefs.remove(_cachedCategoriesKey);
  }
}
