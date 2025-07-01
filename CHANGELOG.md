## 2.0.0

### New Features
- **Added `MuListener<S>`** - Perform side effects in response to state changes (navigation, dialogs, etc.)
- **Added `MuMultiListener`** - Listen to multiple state changes with a single widget
- **Added `MuConsumer<S>`** - Combines `MuBuilder` and `MuListener` functionality
- **Enhanced `MuProvider<T>`** - Now fully generic, works with any type (not just logic classes)
- **Improved documentation** - Comprehensive README with better examples and usage patterns

### Breaking Changes
- **`MuProvider<T>`** is now generic for any type instead of `MuProvider<L, S>`
- Constructor parameter renamed from `logic` to `value` to reflect generic nature

### Improvements
- **Auto-disposal** - `MuProvider` automatically disposes `ChangeNotifier` instances

### Architecture
This release represents the mature, stable API for `mu_state`. The complete widget set now provides:
- State management with `MuLogic<S>` and `MuBuilder<S>`
- Side effects with `MuListener<S>` and `MuConsumer<S>`  
- Dependency injection with generic `MuProvider<T>`
- Multi-state handling with `MuMultiBuilder` and `MuMultiListener`

## 1.1.0

- **Added `MuMultiProvider`** - Clean nesting of multiple providers
- **Enhanced example** - Login feature with MuMultiProvider and repository pattern
- **Documentation improvements** - Better README structure

## 1.0.0

### New Features
- `MuLogic<T>` - Renamed from `MuState` for clarity (still an alias for `ValueNotifier`)
- `MuProvider<L, S>` - Provides logic instances to widget tree using `InheritedWidget`
- `context.logic<T>()` extension - Easy access to logic from context
- `MuComparable` mixin - Lightweight alternative to Equatable for state equality

### Breaking Changes
- **RENAMED**: `MuState` → `MuLogic<T>` for better clarity
- **REMOVED**: Pre-defined state classes (`MuEvent`, `MuLoading`, `MuError`, `MuData`)
- Users now define their own immutable state classes with `MuComparable`

### Architecture
- Encouraging Cubit-style pattern: one logic class per page/feature
- Custom state classes instead of pre-defined ones

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
