import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';
import 'package:wedlist/core/item/item_entity.dart';
import 'package:wedlist/core/router/app_router.dart';
import 'package:wedlist/core/services/item_limit_service.dart';
import 'package:wedlist/core/user/user_service.dart';
import 'package:wedlist/core/utils/colors.dart';
import 'package:wedlist/core/widgets/dialogs/item_limit_dialog.dart';
import 'package:wedlist/feature/dowrylist/presentation/blocs/bloc/dowry_list_bloc.dart';
import 'package:wedlist/feature/item_add/presentation/bloc/add_item_bloc.dart';
import 'package:wedlist/feature/item_add/presentation/bloc/add_photo_cubit/add_photo_cubit.dart';
import 'package:wedlist/injection_container.dart';

class AddToDowryButton extends StatefulWidget {
  const AddToDowryButton({
    required this.item,
    required this.price,
    required this.note,
    super.key,
  });

  final ItemEntity item;
  final String price;
  final String note;

  @override
  State<AddToDowryButton> createState() => _AddToDowryButtonState();
}

class _AddToDowryButtonState extends State<AddToDowryButton>
    with SingleTickerProviderStateMixin {
  bool _clicked = false;
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _colorAnimation = ColorTween(
      begin: AppColors.textColor,
      end: Colors.green,
    ).animate(_controller);
  }

  @override
  void dispose() {
    // Animasyon çalışıyorsa durdur ve iptal et
    if (_controller.isAnimating) {
      _controller.stop(canceled: true);
    }
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handlePressed(BuildContext context) async {
    if (_clicked) return;

    // Item limit kontrolü
    final limitService = sl<ItemLimitService>();
    final canAdd = await limitService.canAddItem();

    if (!canAdd) {
      // Limit doldu, dialog göster
      if (!mounted) return;
      final result = await showItemLimitDialog(context);

      // Kullanıcı iptal etti veya rewarded ad başarısız
      if (result != true) {
        return; // Item ekleme iptal
      }
      // Rewarded ad izlendi, devam et
    }

    // Item ekleme işlemine devam et
    if (!mounted) return;
    setState(() => _clicked = true);
    final imgUrl = context.read<AddPhotoCubit>().state.imageUrl;
    context.read<AddItemBloc>().add(
      AddItemButtonPressed(
        id: widget.item.id,
        title: widget.item.title,
        category: widget.item.category,
        price: widget.price,
        note: widget.note,
        imgUrl: imgUrl,
      ),
    );
    // Başarılı olduğunda dinleyici içinde yönlendireceğiz; burada sadece animasyonu başlatıyoruz
    if (mounted && !_controller.isAnimating) {
      await _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final photoState = context.watch<AddPhotoCubit>().state;
    final isUploading = photoState.status == AddPhotoStatus.loading;
    final isDisabled = _clicked || isUploading; // Fotoğraf zorunlu değil
    return BlocListener<AddItemBloc, AddItemState>(
      listener: (context, state) async {
        if (state is AddItemSuccess) {
          // Item başarıyla eklendi, limit service'i güncelle
          await sl<ItemLimitService>().onItemAdded();

          // Çeyiz listesi tazelenmeli ki Wishlist filtre anında güncellensin
          context.read<DowryListBloc>().add(FetchDowryListItems());
          // Partner sahiplik simetrisini hızlıca iyileştir (özellikle acceptance sonrası ilk ekleme senaryosu)
          try {
            await sl<UserService>().ensureUserItemsSymmetric();
          } on Exception catch (_) {}
          if (!mounted || !context.mounted) return;
          context.go(AppRoute.main.path);
        } else if (state is AddItemFailure) {
          if (!mounted || !context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          if (mounted) {
            setState(() {
              _clicked = false;
            });
            if (!_controller.isAnimating) {
              await _controller.reverse();
            }
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 100, right: 100, bottom: 16),
        child: AnimatedBuilder(
          animation: _colorAnimation,
          builder: (context, child) {
            return FilledButton(
              onPressed: isDisabled ? null : () => _handlePressed(context),
              style: FilledButton.styleFrom(
                fixedSize: const Size(170, 50),
                backgroundColor: AppColors.primary,
                // padding: padding,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                elevation: 0,
              ),
              child: Text(
                _clicked
                    ? context.loc.itemAddedSuccess
                    : isUploading
                    ? context.loc.itemLoadingButtonText
                    : context.loc.addItemButtonText,
              ),
            );
          },
        ),
      ),
    );
  }
}
