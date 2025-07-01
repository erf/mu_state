import 'package:example/home_page/home_page_logic.dart';
import 'package:example/home_page/home_page_state.dart';
import 'package:example/login/login_widget.dart';
import 'package:flutter/material.dart';
import 'package:mu_state/mu_state.dart';

/// Helper function to convert message types to localized strings
String getLocalizedMessage(
    BuildContext context, HomePageMessage messageType, String? messageData) {
  switch (messageType) {
    case HomePageMessage.welcome:
      return 'Welcome to the mu_state example!';
    case HomePageMessage.welcomeWithUser:
      return 'Welcome back, ${messageData ?? 'User'}!';
    case HomePageMessage.counterIncremented:
      return 'Counter incremented to ${messageData ?? '0'}';
    case HomePageMessage.counterDecremented:
      return 'Counter decremented to ${messageData ?? '0'}';
    case HomePageMessage.counterReset:
      return 'Counter has been reset to 0';
    case HomePageMessage.counterIncrementedAsync:
      return 'Counter incremented asynchronously to ${messageData ?? '0'}';
    case HomePageMessage.incrementingCounter:
      return 'Incrementing counter...';
    case HomePageMessage.loadingItems:
      return 'Loading items...';
    case HomePageMessage.itemsLoadedSuccess:
      return 'Successfully loaded ${messageData ?? '0'} new items!';
    case HomePageMessage.itemsCleared:
      return 'All items cleared';
    case HomePageMessage.networkError:
      return 'Network error: ${messageData ?? 'Unknown error'}';
    case HomePageMessage.incrementError:
      return 'Error incrementing counter: ${messageData ?? 'Unknown error'}';
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = context.logic<HomePageLogic>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('mu_state Example'),
      ),
      body: MuBuilder<HomePageState>(
        valueListenable: logic,
        builder: (context, state, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Login/User Section
                const LoginWidget(),

                const SizedBox(height: 16),

                // Status Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Page Status',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              switch ((state.status)) {
                                HomePageStatus.idle => Icons.circle_outlined,
                                HomePageStatus.loading => Icons.refresh,
                                HomePageStatus.success => Icons.check_circle,
                                HomePageStatus.error => Icons.error,
                              },
                              color: switch ((state.status)) {
                                HomePageStatus.idle => Colors.grey,
                                HomePageStatus.loading => Colors.blue,
                                HomePageStatus.success => Colors.green,
                                HomePageStatus.error => Colors.red,
                              },
                            ),
                            const SizedBox(width: 8),
                            Text(state.status.name.toUpperCase()),
                            if (state.isLoading) ...[
                              const SizedBox(width: 16),
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          getLocalizedMessage(
                              context, state.messageType, state.messageData),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Counter Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Counter',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${state.counter}',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          children: [
                            ElevatedButton(
                              onPressed:
                                  state.isLoading ? null : logic.decrement,
                              child: const Text('-1'),
                            ),
                            ElevatedButton(
                              onPressed:
                                  state.isLoading ? null : logic.increment,
                              child: const Text('+1'),
                            ),
                            ElevatedButton(
                              onPressed:
                                  state.isLoading ? null : logic.incrementAsync,
                              child: const Text('+1 Async'),
                            ),
                            ElevatedButton(
                              onPressed: state.isLoading ? null : logic.reset,
                              child: const Text('Reset'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Items Section
                SizedBox(
                  height: 300, // Fixed height instead of Expanded
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Items (${state.items.length})',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Wrap(
                                spacing: 8,
                                children: [
                                  ElevatedButton(
                                    onPressed: state.isLoading
                                        ? null
                                        : logic.loadItems,
                                    child: const Text('Load Items'),
                                  ),
                                  ElevatedButton(
                                    onPressed:
                                        state.items.isEmpty || state.isLoading
                                            ? null
                                            : logic.clearItems,
                                    child: const Text('Clear'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: state.items.isEmpty
                                ? const Center(
                                    child: Text(
                                        'No items yet. Tap "Load Items" to start.'),
                                  )
                                : ListView.builder(
                                    itemCount: state.items.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        leading: CircleAvatar(
                                          child: Text('${index + 1}'),
                                        ),
                                        title: Text(state.items[index]),
                                        subtitle:
                                            Text('Added at position $index'),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
