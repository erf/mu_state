## 1.0.0

**MAJOR RELEASE**: Complete refactor towards a more pragmatic, minimalist approach.

### New Features
- `MuLogic<T>` - Main class for managing state and logic (alias for `ValueNotifier`)
- `MuProvider<L, S>` - Provides logic instances to widget tree using `InheritedNotifier`
- `context.logic<T>()` extension - Easy access to logic from context
- `MuComparable` mixin - Lightweight alternative to Equatable for state equality

### Breaking Changes
- **REMOVED**: `MuState`, `MuEvent`, `MuLoading`, `MuError`, `MuData` classes
- Users must define their own immutable state classes per page/feature
- Use `MuLogic` instead of `MuState`
- Use custom state classes instead of `MuEvent` subclasses

### Philosophy Changes
- One logic class per page/feature (similar to Cubit pattern)
- Custom immutable state classes with `MuComparable` or `Equatable`
- Direct value assignment (`value = ...`) instead of `emit()`
- Minimal Flutter dependencies only (`flutter/foundation.dart`, `flutter/widgets.dart`)

### Unchanged
- `MuBuilder<T>` - Still an alias for `ValueListenableBuilder`
- `MuMultiBuilder` - Listen to multiple `ValueNotifier` objects

### Migration Guide
1. Replace `MuState` with `MuLogic<T>`
2. Replace `MuEvent<T>` usage with custom state classes
3. Use `MuProvider` and `context.logic<T>()` for dependency injection
4. Add `MuComparable` mixin to state classes for equality comparison

## 0.5.0

- let's keep the old names to avoid breaking changes (except for events!)
- note `MuState` is just an alias for `ValueNotifier` and can take any type
- note `MuBuilder` is just an alias for `ValueListenableBuilder`
- note `MuEvent` is optional

## 0.4.0

- renamed `MuState` to `MuLogic` !BREAKING!
- renamed `MuEvent` to `MuState` !BREAKING!
- `MuLogic` is now just an alias for `ValueNotifier` and can take any type (`MuState` is optional)
- `MuBuilder` is now just an alias for `ValueListenableBuilder`

## 0.3.0

- use explicit type for MuEvent

## 0.2.0

- replace complex mu_event type with 4 sealed types (BREAKING)
- use switch expression / patterns to handle mu_event types
- bump sdk version to 3.0.0

## 0.1.1

- update CHANGELOG

## 0.1.0

- user super in constructors
- update lints -> 3.0.1
- sdk env 2.18.0 < 4.0.0
- add vscode example launcher

## 0.0.4

- replace AnimatedBuilder -> ListenableBuilder
- Set min SDK version to 3.0.0 and Flutter to 3.10.0

## 0.0.3+1

- Add widget tests and improve unit tests
- Improve example in README

## 0.0.3

- Remove duplicate MuBuilder declaration

## 0.0.2

- Split classes into separate files under lib/src

## 0.0.1

- Initial release
