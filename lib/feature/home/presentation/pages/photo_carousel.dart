import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedlist/core/utils/paddings.dart';
import 'package:wedlist/feature/dowrylist/presentation/blocs/bloc/dowry_list_bloc.dart';
import 'package:wedlist/feature/dowrylist/presentation/pages/dowry_item_card.dart';
// Indicator removed temporarily

class PhotoCarousel extends StatefulWidget {
  const PhotoCarousel({super.key});

  @override
  State<PhotoCarousel> createState() => _PhotoCarouselState();
}

class _PhotoCarouselState extends State<PhotoCarousel> {
  int currentIndex = 0;
  final String _title = 'Son Eklenenler';

  @override
  void initState() {
    super.initState();
    // Hot restart veya ilk açılışta listeyi yükle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<DowryListBloc>().add(FetchDowryListItems());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.xLargeOnlyTop,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_title, style: Theme.of(context).textTheme.headlineSmall),
          Padding(
            padding: AppPaddings.mediumOnlyTop,
            child: SizedBox(
              height: MediaQuery.of(context).size.width * 1.5,
              child: BlocBuilder<DowryListBloc, DowryListState>(
                builder: (context, state) {
                  if (state is! DowryListLoaded || state.items.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  final items = List.of(state.items)
                    ..sort((a, b) {
                      final da = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
                      final db = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
                      return db.compareTo(da);
                    });
                  final controller = PageController(viewportFraction: 0.92, initialPage: currentIndex);
                  return Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          itemCount: items.length,
                          controller: controller,
                          onPageChanged: (index) => setState(() => currentIndex = index),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return DowryItemCard(item: item);
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      // TODO(wedlist): Add page indicator back (e.g., SmoothPageIndicator)
                      const SizedBox(height: 8),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
