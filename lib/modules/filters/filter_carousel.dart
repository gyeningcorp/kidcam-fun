import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_fonts.dart';
import '../../core/models/filter_definition.dart';
import 'filter_registry.dart';

/// The currently selected filter index.
final selectedFilterIndexProvider = StateProvider<int>((_) => 0);

/// The currently selected filter definition.
final selectedFilterProvider = Provider<FilterDefinition>((ref) {
  final index = ref.watch(selectedFilterIndexProvider);
  final filters = FilterRegistry.allFilters;
  return filters[index.clamp(0, filters.length - 1)];
});

/// Horizontal swipeable filter selector at the bottom of the camera screen.
///
/// Shows filter thumbnails with emoji + label. The active filter
/// is highlighted with a glowing ring.
class FilterCarousel extends ConsumerWidget {
  const FilterCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedFilterIndexProvider);
    final filters = FilterRegistry.allFilters;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Page indicator dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(filters.length, (i) {
            return Container(
              width: i == selectedIndex ? 10 : 6,
              height: i == selectedIndex ? 10 : 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == selectedIndex
                    ? AppColors.white
                    : AppColors.white.withOpacity(0.4),
              ),
            );
          }),
        ),
        const SizedBox(height: 12),

        // Filter thumbnail strip
        SizedBox(
          height: 80,
          child: PageView.builder(
            controller: PageController(
              viewportFraction: 0.2,
              initialPage: selectedIndex,
            ),
            itemCount: filters.length,
            onPageChanged: (index) {
              ref.read(selectedFilterIndexProvider.notifier).state = index;
            },
            itemBuilder: (context, index) {
              final filter = filters[index];
              final isActive = index == selectedIndex;

              return GestureDetector(
                onTap: () {
                  ref.read(selectedFilterIndexProvider.notifier).state = index;
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? AppColors.white.withOpacity(0.3)
                        : AppColors.inactiveFilterBg,
                    border: isActive
                        ? Border.all(
                            color: AppColors.activeFilterRing,
                            width: 3,
                          )
                        : null,
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: AppColors.white.withOpacity(0.4),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        filter.emoji,
                        style: TextStyle(
                          fontSize: isActive ? 28 : 22,
                        ),
                      ),
                      if (isActive)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            filter.displayName,
                            style: AppFonts.filterLabel,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
