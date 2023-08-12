## 0.4.1

- Fix for inline char arrays and char pointers

## 0.4.0

- Support for Steam SDK 1.57
- Dart 3
- Update linter to aeb_lint

## 0.3.2

- Remove unnecessary `ffi` package

## 0.3.1

- Revert struct packing since it did not released on stable channel yet.

## 0.3.0

- Generate C enums as Dart Enhanced Enums.
- Functions with Enums made more readable by introducing C and Dart type aliases.
- Struct packing changed according to the fixes in [this issue](https://github.com/dart-lang/sdk/issues/46644)

## 0.2.4

- Library loading based on operating system.

## 0.2.3

- Do not generate `ISteamController` since it is deprecated, it is real this time.

## 0.2.2

- Do not generate `ISteamController` since it is deprecated.
- Fix for constant generation

## 0.2.1

- Ignore linter public_member_api_docs for generated files

## 0.2.0

- Enum and interface naming has been changed
- Single export file for generated files
- From now on global interfaces are called initializers

## 0.1.1

- README correction

## 0.1.0

- Initial version.
