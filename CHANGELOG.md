# Changelog

All notable changes to this project are documented here. Versions follow `box.json`.
Only `v2.0.0` is tagged in git; other entries are dated from the commit that set the version.

> **Breaking changes** are flagged with ⚠️.

## [2.2.0] - 2025-04-08
### Added
- `caseSensitive` argument (default `false`) on `diff()`, `diffByKey()` and `isSame()`. New helper `isSameSimpleValue()`. (#3)
### Changed
- Dev dependency `testbox` is now `6.3.0+13`.
- Functions declare return types and use `arguments.` scoping (e.g. `boolean numericCheck()`, `boolean isSame()`, `array diff()`).
### Notes
- Default behavior is unchanged (case-insensitive). No breaking changes expected, unless you override or call internal helpers with untyped/non-boolean values.

## [2.1.1] - 2025-03-18 (approx. 2.1.x range)
### Fixed
- `diffPatch()` when items are added to arrays.
- HTML output (`displayDiff()`) now serializes object/array changes to JSON for display.
- `diff()` handles `null` values in arrays and objects.
### Notes
- ⚠️ Possible behavior change: `diff()` results for inputs containing `null` differ from earlier versions.

## [2.0.0] - 2023-02-07 (tag `v2.0.0`)
### Added
- `patch(original, diff)` – applies a diff to a copy of the original.
- `diffpatch(original, diff)` – annotates every value as `{old, new, type}` (`SAME` for unchanged).
- `displayDiff(original, diff)` – returns an HTML view of the changes.
- Helpers `runPatch()` and `diffToHTML()`.
- New specs: `ArraySpec`, `BasicSpec`, `diffPatchSpec`, `displayDiffSpec`.
### Changed
- Major version bump; `diff()` / `diffByKey()` signatures unchanged. Code formatting cleanup.
### Notes
- Readme was not updated with the new functions.

## [1.1.3] - 2022-07-18
### Changed
- ⚠️ `diffByKey()` returns a plain value for single-column keys and an **array** for composite keys (e.g. `[48280, 1988]`), instead of a joined string (`"48280_1988"`). Code comparing against the string form must be updated.
- Internal variables are cleaned up after use.

## [1.1.2] - 2022-07-08
### Added
- `key` field on struct changes in `diffByKey()` results (PR #2).

## [1.1.1] - 2022-06-09
### Added
- `diffByKey()` for arrays and queries.
### Fixed
- Error when there are no changed items.

## [1.0.x] - 2021-12 to 2022-01
### Added
- Initial release: `diff()` with ignored-keys support, Readme, MIT license (2022-05).
### Fixed
- CF compatibility (trailing comma, `prepend` instead of `unshift`).
- Handling of differing number types and `null`; numeric check refactored (`isNumeric` was problematic).

## Upgrade guide
- 1.x → 2.0: update any code relying on string composite keys from `diffByKey()` (see 1.1.3).
- 2.0 → 2.2: no required changes; opt in to `caseSensitive` where needed.
