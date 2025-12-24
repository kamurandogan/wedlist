import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedlist/core/entities/user_item_entity.dart';
import 'package:wedlist/feature/chart/domain/usecases/compute_category_spending.dart';
import 'package:wedlist/feature/chart/presentation/bloc/chart_bloc.dart';
import 'package:wedlist/feature/chart/presentation/ui/atoms/spending_legend.dart';
import 'package:wedlist/feature/chart/presentation/ui/colors/chart_palette.dart';
import 'package:wedlist/feature/chart/presentation/ui/molecules/category_pie_chart.dart';
import 'package:wedlist/feature/dowrylist/presentation/blocs/bloc/dowry_list_bloc.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) {
        final bloc = ChartBloc(const ComputeCategorySpending());
        final dowryState = ctx.read<DowryListBloc>().state;
        final items = dowryState.maybeWhen(
          loaded: (items) => items,
          empty: (_) => const <UserItemEntity>[],
          orElse: () => null,
        );
        if (items != null) {
          bloc.add(ChartRebuildFromItems(items));
        }
        return bloc;
      },
      child: BlocListener<DowryListBloc, DowryListState>(
        listenWhen: (prev, curr) => curr.maybeWhen(
          loaded: (_) => true,
          empty: (_) => true,
          orElse: () => false,
        ),
        listener: (ctx, state) {
          final chartBloc = ctx.read<ChartBloc>();
          state.maybeWhen(
            loaded: (items) => chartBloc.add(ChartRebuildFromItems(items)),
            empty: (_) => chartBloc.add(ChartRebuildFromItems(const [])),
            orElse: () {},
          );
        },
        child: BlocBuilder<ChartBloc, ChartState>(
          builder: (context, state) {
            if (state is ChartLoaded) {
              return Card(
                elevation: 0,
                color: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      CategoryPieChart(data: state.items),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          children: [
                            for (var i = 0; i < state.items.length; i++)
                              SpendingLegend(
                                color: ChartPalette.adaptive(
                                  context,
                                )[i % ChartPalette.pastel.length],
                                label: state.items[i].category,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is ChartEmpty) {
              return const Center(child: Text('Veri yok'));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
