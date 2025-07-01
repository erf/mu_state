import 'package:example/home_page/home_page_state.dart';
import 'package:example/repository/auth_repository.dart';
import 'package:mu_state/mu_state.dart';

class HomePageLogic extends MuLogic<HomePageState> {
  final AuthRepository? _authRepository;

  HomePageLogic([this._authRepository])
      : super(const HomePageState(
          counter: 0,
          messageType: HomePageMessage.welcome,
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
      messageType: user != null
          ? HomePageMessage.welcomeWithUser
          : HomePageMessage.welcome,
      messageData: user,
    );
  }

  void increment() {
    value = value.copyWith(
      counter: value.counter + 1,
      messageType: HomePageMessage.counterIncremented,
      messageData: (value.counter + 1).toString(),
      status: HomePageStatus.idle,
    );
  }

  void decrement() {
    value = value.copyWith(
      counter: value.counter - 1,
      messageType: HomePageMessage.counterDecremented,
      messageData: (value.counter - 1).toString(),
      status: HomePageStatus.idle,
    );
  }

  void reset() {
    value = value.copyWith(
      counter: 0,
      messageType: HomePageMessage.counterReset,
      messageData: null,
      status: HomePageStatus.idle,
    );
  }

  Future<void> incrementAsync() async {
    value = value.copyWith(
      isLoading: true,
      messageType: HomePageMessage.incrementingCounter,
      status: HomePageStatus.loading,
    );

    try {
      // Simulate async operation
      await Future.delayed(const Duration(seconds: 1));

      value = value.copyWith(
        counter: value.counter + 1,
        isLoading: false,
        messageType: HomePageMessage.counterIncrementedAsync,
        messageData: (value.counter + 1).toString(),
        status: HomePageStatus.success,
      );
    } catch (e) {
      value = value.copyWith(
        isLoading: false,
        messageType: HomePageMessage.incrementError,
        messageData: e.toString(),
        status: HomePageStatus.error,
      );
    }
  }

  Future<void> loadItems() async {
    value = value.copyWith(
      isLoading: true,
      status: HomePageStatus.loading,
      messageType: HomePageMessage.loadingItems,
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
        messageType: HomePageMessage.itemsLoadedSuccess,
        messageData: newItems.length.toString(),
      );
    } catch (e) {
      value = value.copyWith(
        isLoading: false,
        status: HomePageStatus.error,
        messageType: HomePageMessage.networkError,
        messageData: e.toString(),
      );
    }
  }

  void clearItems() {
    value = value.copyWith(
      items: [],
      messageType: HomePageMessage.itemsCleared,
      status: HomePageStatus.idle,
    );
  }

  @override
  void dispose() {
    _authRepository?.currentUser.removeListener(_onAuthChanged);
    super.dispose();
  }
}
