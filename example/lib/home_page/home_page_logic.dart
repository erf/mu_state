import 'package:example/repository/auth_repository.dart';
import 'package:example/home_page/home_page_state.dart';
import 'package:mu_state/mu_state.dart';

class HomePageLogic extends MuLogic<HomePageState> {
  final AuthRepository? _authRepository;

  HomePageLogic([this._authRepository])
      : super(const HomePageState(
          counter: 0,
          message: 'Welcome! Tap the buttons to interact.',
          isLoading: false,
          items: [],
          status: HomePageStatus.idle,
        )) {
    // Listen to auth changes if repository is provided
    _authRepository?.currentUser.addListener(_onAuthChanged);
  }

  void _onAuthChanged() {
    final user = _authRepository?.currentUser.value;
    value = value.copyWith(
      currentUser: user,
      message: user != null
          ? 'Welcome back, $user! Tap the buttons to interact.'
          : 'Welcome! Tap the buttons to interact.',
    );
  }

  void increment() {
    value = value.copyWith(
      counter: value.counter + 1,
      message: 'Counter incremented to ${value.counter + 1}',
    );
  }

  void decrement() {
    value = value.copyWith(
      counter: value.counter - 1,
      message: 'Counter decremented to ${value.counter - 1}',
    );
  }

  void reset() {
    value = value.copyWith(
      counter: 0,
      message: 'Counter reset to 0',
    );
  }

  Future<void> incrementAsync() async {
    value = value.copyWith(
      isLoading: true,
      message: 'Incrementing counter...',
      status: HomePageStatus.loading,
    );

    try {
      // Simulate async operation
      await Future.delayed(const Duration(seconds: 1));

      value = value.copyWith(
        counter: value.counter + 1,
        isLoading: false,
        message: 'Counter incremented to ${value.counter + 1} (async)',
        status: HomePageStatus.success,
      );
    } catch (e) {
      value = value.copyWith(
        isLoading: false,
        message: 'Failed to increment counter: $e',
        status: HomePageStatus.error,
      );
    }
  }

  Future<void> loadItems() async {
    value = value.copyWith(
      isLoading: true,
      status: HomePageStatus.loading,
      message: 'Loading items...',
    );

    try {
      // Simulate network call
      await Future.delayed(const Duration(seconds: 2));

      // Simulate random success/failure
      if (DateTime.now().millisecondsSinceEpoch % 3 == 0) {
        throw Exception('Network error occurred');
      }

      final newItems = List.generate(
        5,
        (index) => 'Item ${value.items.length + index + 1}',
      );

      value = value.copyWith(
        isLoading: false,
        status: HomePageStatus.success,
        items: [...value.items, ...newItems],
        message: 'Successfully loaded ${newItems.length} new items!',
      );
    } catch (e) {
      value = value.copyWith(
        isLoading: false,
        status: HomePageStatus.error,
        message: 'Error: $e',
      );
    }
  }

  void clearItems() {
    value = value.copyWith(
      items: [],
      message: 'All items cleared',
      status: HomePageStatus.idle,
    );
  }

  @override
  void dispose() {
    _authRepository?.currentUser.removeListener(_onAuthChanged);
    super.dispose();
  }
}
