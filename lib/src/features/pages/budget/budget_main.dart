import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'budget_screen.dart';
import 'create_budget.dart';

class Budgets extends StatefulWidget {
  const Budgets({super.key});

  @override
  State<Budgets> createState() => _BudgetsState();
}

class _BudgetsState extends State<Budgets> {
  bool _isEmpty = true;

  Future<void> checkList() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('budget').get();
    setState(() {
      _isEmpty = snapshot.docs.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isEmpty ? Budget() : const BudgetMain();
  }
}

class BudgetMain extends StatefulWidget {
  const BudgetMain({super.key});

  @override
  State<BudgetMain> createState() => _BudgetMainState();
}

class _BudgetMainState extends State<BudgetMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.shade50,
              radius: 85,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blue.shade50,
                child: Image.asset("assets/images/img_15.png"),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Create your first budget",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                "Spend more wisely by setting limits for your top spend categories",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => CreateBudget(),
                    isScrollControlled: true,
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(10)),
                    maximumSize:
                        Size(MediaQuery.of(context).size.width * 0.52, 60)),
                child: const Text(
                  "Create a budget",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
