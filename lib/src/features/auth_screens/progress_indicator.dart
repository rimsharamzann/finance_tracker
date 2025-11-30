import 'package:finance_tracker/src/features/onBoarding/on_boarding.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constants/colors.dart';
import '../onBoarding/screens.dart';

class ProgressIndicator extends StatefulWidget {
  const ProgressIndicator({super.key});

  @override
  State<ProgressIndicator> createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator> {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 60,
        ),
        SmoothPageIndicator(
          controller: _pageController,
          count: 3,
          effect: ExpandingDotsEffect(
            activeDotColor: MyColors.primaryColor,
            dotColor: Colors.grey.shade300,
            dotHeight: 1,
            dotWidth: 100,
            spacing: 4,
          ),
        ),
        const SizedBox(
          height: 60,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: PageView(
            controller: _pageController,
            children: const [
              OnBoarding(),
              OnBoarding2(),
              OnBoarding3(),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
