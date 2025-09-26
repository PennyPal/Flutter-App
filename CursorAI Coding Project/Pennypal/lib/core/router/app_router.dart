import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'route_names.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/welcome/presentation/pages/welcome_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/transactions/presentation/pages/transactions_page.dart';
import '../../features/transactions/presentation/pages/transaction_add_page.dart';
import '../../features/budgets/presentation/pages/budgets_page.dart';
import '../../features/budgets/presentation/pages/budget_add_page.dart';
import '../../features/goals/presentation/pages/goals_page.dart';
import '../../features/learn/presentation/pages/learn_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/quests/presentation/pages/quests_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../shared/widgets/layout/main_layout.dart';

/// Provider for the app router
final appRouterProvider = Provider<GoRouter>((ref) {
  return AppRouter._create(ref);
});

/// Main app router configuration
class AppRouter {
  AppRouter._();

  static GoRouter _create(Ref ref) {
    return GoRouter(
      debugLogDiagnostics: true,
      initialLocation: RouteNames.splash,
      routes: [
        // Splash & Onboarding
        GoRoute(
          path: RouteNames.splash,
          name: 'splash',
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: RouteNames.onboarding,
          name: 'onboarding',
          builder: (context, state) => const OnboardingPage(),
        ),
        GoRoute(
          path: '/welcome',
          name: 'welcome',
          builder: (context, state) => const WelcomePage(),
        ),

        // Authentication
        GoRoute(
          path: RouteNames.login,
          name: 'login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: RouteNames.register,
          name: 'register',
          builder: (context, state) => const RegisterPage(),
        ),

        // Main app with bottom navigation
        ShellRoute(
          builder: (context, state, child) => MainLayout(child: child),
          routes: [
            // Dashboard/Home
            GoRoute(
              path: RouteNames.home,
              name: 'home',
              builder: (context, state) => const DashboardPage(),
            ),

            // Transactions
            GoRoute(
              path: RouteNames.transactions,
              name: 'transactions',
              builder: (context, state) => const TransactionsPage(),
              routes: [
                GoRoute(
                  path: '/add',
                  name: 'transaction-add',
                  builder: (context, state) => const TransactionAddPage(),
                ),
                GoRoute(
                  path: '/edit/:id',
                  name: 'transaction-edit',
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return TransactionAddPage(transactionId: id);
                  },
                ),
              ],
            ),

            // Budgets
            GoRoute(
              path: RouteNames.budgets,
              name: 'budgets',
              builder: (context, state) => const BudgetsPage(),
            ),

            // Goals
            GoRoute(
              path: RouteNames.goals,
              name: 'goals',
              builder: (context, state) => const GoalsPage(),
            ),

            // Learning
            GoRoute(
              path: RouteNames.learn,
              name: 'learn',
              builder: (context, state) => const LearnPage(),
            ),

            // Chat & AI
            GoRoute(
              path: RouteNames.chat,
              name: 'chat',
              builder: (context, state) => const ChatPage(),
            ),

            // Quests
            GoRoute(
              path: RouteNames.quests,
              name: 'quests',
              builder: (context, state) => const QuestsPage(),
            ),

            // Profile
            GoRoute(
              path: RouteNames.profile,
              name: 'profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),

        // Add Transaction (outside main layout)
        GoRoute(
          path: RouteNames.transactionAdd,
          name: 'transactionAdd',
          builder: (context, state) => const TransactionAddPage(),
        ),

        // Add Budget (outside main layout)
        GoRoute(
          path: RouteNames.budgetAdd,
          name: 'budgetAdd',
          builder: (context, state) => const BudgetAddPage(),
        ),

        // Settings (outside main layout)
        GoRoute(
          path: RouteNames.settings,
          name: 'settings',
          builder: (context, state) => const SettingsPage(),
        ),
      ],
      
      // Redirect logic for authentication
      redirect: (context, state) {
        // TODO: Implement authentication redirect logic
        // This will be implemented when we add authentication providers
        return null;
      },

      // Error page
      errorBuilder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Page not found',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                state.error?.toString() ?? 'Unknown error',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go(RouteNames.home),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

