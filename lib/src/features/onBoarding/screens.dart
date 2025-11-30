import 'package:flutter/material.dart%20';

class Screens extends StatefulWidget {
  const Screens({super.key});

  @override
  State<Screens> createState() => _ScreensState();
}

class _ScreensState extends State<Screens> {
  late var _pageController = PageController();

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0,
      keepPage: true,
    );

    _pageController.addListener(() {

      setState(() {
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class OnBoarding1 extends StatelessWidget {
  const OnBoarding1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 60),
        Stack(
          children: [
            Center(
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.white.withValues(alpha: 0.3),
              ),
            ),
            Column(
              children: [
                expenseCard1("Income", "+ \$1,000", Icons.monetization_on_sharp,
                    Colors.green),
                expenseCard1(
                  "Shopping",
                  "- \$800",
                  Icons.shopping_cart,
                  Colors.red,
                ),
                expenseCard1("Food & Drinks", "- \$,100",
                    Icons.emoji_food_beverage, Colors.orange)
              ],
            )
          ],
        ),
        const SizedBox(height: 60),
        const Text(
          "Stay on top of your spends",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        const Text(
          "Easily keep track of all your income and spends at a single place",
          style: TextStyle(color: Colors.white70, fontSize: 11),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget expenseCard1(String title, String amount, IconData icon, Color color) {
    return Container(
      height: 60,
      width: 520,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: color,
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          Text(amount, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}

class OnBoarding3 extends StatelessWidget {
  const OnBoarding3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: 400,
      child: Column(
        children: [
          const SizedBox(height: 50),
          Stack(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                ),
              ),
              Positioned(
                right: 10,
                top: -8,
                child: expenseCard3(
                    "Entertainment", Icons.local_movies_outlined, Colors.pink),
              ),
              Positioned(
                left: 0,
                top: 65,
                child: expenseCard3(
                  "Shopping",
                  Icons.shopping_cart,
                  Colors.green,
                ),
              ),
              Positioned(
                bottom: -10,
                right: 10,
                child: expenseCard3(
                    "Food & Drinks", Icons.emoji_food_beverage, Colors.orange),
              ),
            ],
          ),
          const SizedBox(height: 75),
          const Text(
            "Set your Budget",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            "Spend More wisely by setting limits by your top spend categories",
            style: TextStyle(color: Colors.white70, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget expenseCard3(String title, IconData icon, Color color) {
    return Container(
      height: 55,
      width: 185,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: color,
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OnBoarding2 extends StatelessWidget {
  const OnBoarding2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        SizedBox(
          height: 200,
          child: Stack(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                ),
              ),
              Positioned(
                top: 20,
                left: 40,
                child: expenseCard2("HDFC", "assets/images/img_6.png"),
              ),
              Positioned(
                  top: -10,
                  right: 40,
                  child: expenseCard2("Axis", "assets/images/img_4.png")),
              Positioned(
                  bottom: -10,
                  right: 70,
                  child: expenseCard2("SBI", "assets/images/img_5.png"))
            ],
          ),
        ),
        const SizedBox(height: 75),
        const Text(
          "Connect all your accounts",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        const Text(
          "No More Hassle to check multiple bank account statement",
          style: TextStyle(color: Colors.white70, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

Widget expenseCard2(
  String title,
  String img,
) {
  return Container(
    height: 80,
    width: 80,
    margin: const EdgeInsets.all(10),
    // padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            CircleAvatar(radius: 20, child: Image.asset(img)),
            Text(
              title,
              style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
          ],
        ),
      ],
    ),
  );
}
