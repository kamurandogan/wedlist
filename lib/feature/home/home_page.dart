import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wedlist/core/utils/colors.dart';
import 'package:wedlist/core/utils/paddings.dart';
import 'package:wedlist/feature/chart/presentation/ui/pages/chart_page.dart';
import 'package:wedlist/feature/dowrylist/presentation/blocs/bloc/dowry_list_bloc.dart';
import 'package:wedlist/feature/home/presentation/widgets/home_page_card.dart';
import 'package:wedlist/feature/home/presentation/widgets/progress_widget.dart';
import 'package:wedlist/feature/home/presentation/widgets/remaining_days.dart';
import 'package:wedlist/feature/home/presentation/widgets/totalpaid/total_paid_amount.dart';
import 'package:wedlist/feature/home/presentation/widgets/totalpaid/total_paid_title.dart';
import 'package:wedlist/feature/main_page/presentation/pages/user_detail_line_page.dart';

part 'presentation/pages/total_paid.dart';
part 'presentation/widgets/custom_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserDetailLinePage(),
              // CustomSearchBar(),
              Padding(
                padding: AppPaddings.xLargeOnlyTop,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: HomePageCard(
                        color: AppColors.pastelBlue,
                        child: TotalPaid(),
                      ),
                    ),
                    Expanded(
                      child: HomePageCard(
                        color: AppColors.pastelYellow,
                        child: RemainingDays(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: AppPaddings.mediumOnlyTop,
                child: HomePageCard(
                  color: AppColors.pastelPink,
                  child: ProgressWidget(),
                ),
              ),
              Padding(
                padding: AppPaddings.mediumOnlyTop,
                child: ChartPage(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
