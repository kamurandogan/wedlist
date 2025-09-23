import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';
import 'package:wedlist/core/item/item_entity.dart';
import 'package:wedlist/core/utils/paddings.dart';
import 'package:wedlist/feature/item_add/domain/usecases/add_user_item_usecase.dart';
import 'package:wedlist/feature/item_add/presentation/bloc/add_item_bloc.dart';
import 'package:wedlist/feature/item_add/presentation/bloc/add_photo_cubit/add_photo_cubit.dart';
import 'package:wedlist/feature/item_add/presentation/pages/add_photo_card.dart';
import 'package:wedlist/feature/item_add/presentation/widgets/add_to_dowry_button.dart';
import 'package:wedlist/injection_container.dart';

part 'presentation/widgets/line.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({required this.item, super.key});
  final ItemEntity item;

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  late String category;
  late String price;
  late String count;
  late String note;

  @override
  void initState() {
    super.initState();
    category = widget.item.category;
    price = '';
    count = '';
    note = '';
  }

  String get _title => 'Add Item To Dowry';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AddItemBloc(AddUserItemUseCase(sl()))),
        BlocProvider(create: (_) => sl<AddPhotoCubit>()),
      ],
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(_title, style: Theme.of(context).textTheme.titleMedium),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: AppPaddings.columnPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AddPhotoCard(item: widget.item, price: price, note: note),
                Padding(
                  padding: AppPaddings.smallOnlyTop,
                  child: Line(
                    title: context.loc.priceTitleTextfield,
                    value: price,
                    onChanged: (val) => setState(() => price = val),
                  ),
                ),
                Line(
                  title: context.loc.descriptionTitleTextfield,
                  value: note,
                  onChanged: (val) => setState(() => note = val),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: AddToDowryButton(item: widget.item, price: price, note: note),
        ),
      ),
    );
  }
}
