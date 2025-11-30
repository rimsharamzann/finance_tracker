import 'package:finance_tracker/src/features/pages/profiles/profile_screen.dart';
import 'package:flutter/material.dart%20';

import '../src/features/pages/budget/budget_main.dart';
import '../src/features/pages/home/home_page.dart';
import '../src/features/pages/wallet_pages/wallet.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  final _screens = [
    const HomePage(),
    const Wallet(),
    const Budgets(),
    const Profile(),
  ];
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _screens[_currentIndex],
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        bottomNavigationBar: NavigationBar(
          height: 50,
          shadowColor: Colors.grey.shade400,
          indicatorColor: Colors.white,
          elevation: 2,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          selectedIndex: _currentIndex,
          backgroundColor: Colors.white,
          onDestinationSelected: (int value) {
            setState(() {
              _currentIndex = value;
            });
          },
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined,
                  color: _currentIndex == 0 ? Colors.blue : Colors.grey),
          
              label: 'Home',
            ),
            NavigationDestination(
                icon: Icon(Icons.wallet,
                    color: _currentIndex == 1 ? Colors.blue : Colors.grey),
                label: 'Wallet'),
            NavigationDestination(
                icon: Icon(Icons.attach_money_outlined,
                    color: _currentIndex == 2 ? Colors.blue : Colors.grey),
                label: 'Budget'),
            NavigationDestination(
                icon: Icon(Icons.person_outline_outlined,
                    color: _currentIndex == 3 ? Colors.blue : Colors.grey),
                label: 'Profile'),
          ],
        ));
  }
}
