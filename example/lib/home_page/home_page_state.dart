import 'package:mu_state/mu_state.dart';

enum HomePageStatus { idle, loading, success, error }

class HomePageState with MuComparable {
  final int counter;
  final String message;
  final bool isLoading;
  final List<String> items;
  final HomePageStatus status;

  const HomePageState({
    required this.counter,
    required this.message,
    required this.isLoading,
    required this.items,
    required this.status,
  });

  HomePageState copyWith({
    int? counter,
    String? message,
    bool? isLoading,
    List<String>? items,
    HomePageStatus? status,
  }) {
    return HomePageState(
      counter: counter ?? this.counter,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [counter, message, isLoading, items, status];
}
