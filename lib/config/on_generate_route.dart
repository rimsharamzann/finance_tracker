import 'package:finance_tracker/src/features/auth_screens/splash_screen.dart';
import 'package:finance_tracker/src/features/onBoarding/on_boarding.dart';
import 'package:flutter/material.dart';

import '../src/features/auth_screens/sign_up_screen.dart';
import '../src/features/pages/budget/budget_screen.dart';
import '../src/features/pages/home/home_page.dart';
import '../src/features/pages/wallet_pages/cashwallet/cash_wallet_screen.dart';
import '../src/features/pages/wallet_pages/wallet.dart';
import 'bottom_nav_bar.dart';

mixin RoutesConfig {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/onboarding':
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const OnBoarding(),
        );
      case '/':
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const SplashScreen(),
        );

      case '/login':
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const SignUpScreen(),
        );
      case '/home':
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const BottomNavBar(),
        );

      case '/budget-view':
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => Budget(),
        );
      case '/wallet':
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const Wallet(),
        );
      case '/cash':
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => CashWalletScreen(),
        );
      case '/budget':
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => Budget(),
        );

      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const HomePage(),
        );
    }
  }
}
