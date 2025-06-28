import 'package:mu_state/mu_state.dart';

enum HomePageStatus { idle, loading, success, error }

enum HomePageMessage {
  welcome,
  welcomeWithUser,
  counterIncremented,
  counterDecremented,
  counterReset,
  counterIncrementedAsync,
  incrementingCounter,
  loadingItems,
  itemsLoadedSuccess,
  itemsCleared,
  networkError,
  incrementError,
}

class HomePageState with MuComparable {
  final int counter;
  final HomePageMessage messageType;
  final String? messageData; // For dynamic data like username, count, etc.
  final bool isLoading;
  final List<String> items;
  final HomePageStatus status;
  final String? currentUser;

  const HomePageState({
    required this.counter,
    required this.messageType,
    this.messageData,
    required this.isLoading,
    required this.items,
    required this.status,
    this.currentUser,
  });

  HomePageState copyWith({
    int? counter,
    HomePageMessage? messageType,
    String? messageData,
    bool? isLoading,
    List<String>? items,
    HomePageStatus? status,
    String? currentUser,
  }) {
    return HomePageState(
      counter: counter ?? this.counter,
      messageType: messageType ?? this.messageType,
      messageData: messageData ?? this.messageData,
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      status: status ?? this.status,
      currentUser: currentUser ?? this.currentUser,
    );
  }

  @override
  List<Object?> get props => [
        counter,
        messageType,
        messageData,
        isLoading,
        items,
        status,
        currentUser
      ];
}
