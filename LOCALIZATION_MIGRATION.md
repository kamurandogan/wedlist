# Localization Migration Guide

## Current State

- Added `l10n.yaml` (custom output dir `lib/generated/l10n`).
- Added ARB files: `app_en.arb`, `app_tr.arb`.
- Integrated delegates & supported locales in `main.dart`.
- Added `L10nX` BuildContext extension: `context.loc`.
- Still using old `AppStrings` constants in code (safe fallback during migration).

## Migration Steps

1. Run code generation:

   ```bash
   flutter gen-l10n
   ```

   or just `flutter run` (auto triggers if generate: true).

2. Replace usages incrementally.
   Example:

   ```dart
   // Before
   Text(AppStrings.welcomeMessage)
   // After
   Text(context.loc.welcomeMessage)
   ```

3. If a key is missing in a locale, generation will warn. Check `untranslated.txt`.

4. After all constants replaced:
   - Delete `AppStrings` class file.
   - Search for lingering `AppStrings.` references (should be zero).

5. Adding a new string:
   - Add to `app_en.arb` with English value.
   - Add translation to `app_tr.arb`.
   - Re-run `flutter gen-l10n`.
   - Use via `context.loc.myNewKey`.

## Parameter / Plural Examples

```jsonc
// app_en.arb
"itemsCount": "{count, plural, =0{No items} =1{1 item} other{{count} items}}",
"@itemsCount": {"placeholders": {"count": {"type": "int"}}}
```

Usage:

```dart
Text(context.loc.itemsCount(count))
```

## Fallback Logic

`localeResolutionCallback` returns matching languageCode else English. Add more locales by new ARB + list entry.

## Removing easy_localization

Removed from pubspec. Make sure you also remove any `EasyLocalization` wrappers/imports if they exist elsewhere.

## Firestore Item Titles

No change applied—these remain as stored. UI localization only affects static interface strings.

## QA Checklist

- [ ] App builds without easy_localization imports
- [ ] Running in EN shows English texts
- [ ] Change device/emulator language to Turkish -> TR strings appear
- [ ] `untranslated.txt` is empty (or only expected keys listed)

## Troubleshooting

- Generation errors: ensure ARB is valid JSON (no trailing commas).
- Missing key at runtime: Regenerate; hot reload sometimes insufficient -> do full restart.
- Null check issues: `AppLocalizations.of(context)` can be null only before MaterialApp; use inside widget tree.

Happy translating!
