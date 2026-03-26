import '../../core/models/filter_definition.dart';
import 'filters/cat_filter.dart';
import 'filters/dog_filter.dart';
import 'filters/dinosaur_filter.dart';
import 'filters/princess_filter.dart';
import 'filters/superhero_filter.dart';
import 'filters/pirate_filter.dart';
import 'filters/space_filter.dart';
import 'filters/monster_filter.dart';
import 'filters/rainbow_filter.dart';
import 'filters/snowflake_filter.dart';

/// Central registry of all available face filters.
///
/// The MVP ships with 10 free filters. Premium filters (Phase 2)
/// will be added to this registry behind a purchase gate.
abstract final class FilterRegistry {
  /// All MVP filters in carousel display order.
  static const List<FilterDefinition> allFilters = [
    catFilter,
    dogFilter,
    dinosaurFilter,
    princessFilter,
    superheroFilter,
    pirateFilter,
    spaceFilter,
    monsterFilter,
    rainbowFilter,
    snowflakeFilter,
  ];

  /// Only free filters (MVP = all free).
  static List<FilterDefinition> get freeFilters =>
      allFilters.where((f) => f.category == FilterCategory.free).toList();

  /// Look up a filter by its unique ID.
  static FilterDefinition? findById(String id) {
    try {
      return allFilters.firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Total number of registered filters.
  static int get count => allFilters.length;
}
