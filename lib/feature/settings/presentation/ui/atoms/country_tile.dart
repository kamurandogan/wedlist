import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedlist/core/constants/countries.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';
import 'package:wedlist/feature/settings/presentation/bloc/country_cubit.dart';
import 'package:wedlist/feature/settings/presentation/ui/atoms/settings_page_listtile.dart';

class CountryTile extends StatelessWidget {
  const CountryTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountryCubit, CountryState>(
      builder: (context, state) {
        final code = state.countryCode ?? '-';
        return SettingsPageListtile(
          title: context.loc.changeCountry,
          trailing: Text(code),
          onTap: () => _openPicker(context, state.countryCode),
        );
      },
    );
  }

  void _openPicker(BuildContext context, String? current) {
    final parentCubit = context.read<CountryCubit>();
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                context.loc.changeCountry,
                style: Theme.of(sheetContext).textTheme.titleMedium,
              ),
            ),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: supportedCountries.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (c, i) {
                  final code = supportedCountries[i];
                  final selected = code == current;
                  final display = countryDisplayNames[code] ?? code;
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 16,
                      backgroundColor: Theme.of(
                        sheetContext,
                      ).colorScheme.primary.withValues(alpha: 0.08),
                      child: Text(
                        code,
                        style: Theme.of(sheetContext).textTheme.labelMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    title: Text(display),
                    subtitle: Text(code),
                    trailing: selected
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () => _select(code, parentCubit, sheetContext),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<void> _select(
    String code,
    CountryCubit cubit,
    BuildContext ctx,
  ) async {
    try {
      await cubit.change(code);
      if (!ctx.mounted) return; // async gap sonrası context kontrolü
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content: Text('${ctx.loc.changeCountry}: $code')),
      );
    } on Exception catch (e) {
      if (!ctx.mounted) return;
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content: Text('${ctx.loc.errorPrefix} $e')),
      );
    } finally {
      if (ctx.mounted) {
        Navigator.of(ctx).pop();
      }
    }
  }
}
