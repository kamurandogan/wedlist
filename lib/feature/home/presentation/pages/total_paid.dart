part of '../../home_page.dart';

class TotalPaid extends StatelessWidget {
  const TotalPaid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DowryListBloc, DowryListState>(
      builder: (context, state) {
        double total = 0;
        if (state is DowryListLoaded) {
          total = state.items.fold<double>(0, (double sum, e) => sum + e.price);
        }
        // final locale = Localizations.localeOf(context).toString();
        // final amountText = _formatCurrency(locale, total);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TotalPaidTitle(),
            TotalPaidAmount(amountText: total.toStringAsFixed(2)),
          ],
        );
      },
    );
  }
}
