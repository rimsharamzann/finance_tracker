import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/src/features/pages/budget/show_budget.dart';
import 'package:flutter/material.dart%20';

import '../../../constants/models/budget_model.dart';
import '../../../constants/models/transaction_model.dart';
import 'create_budget.dart';

// ignore: must_be_immutable
class Budget extends StatefulWidget {
  Budget({super.key, this.transaction});

  TransactionModel? transaction;

  @override
  State<Budget> createState() => _HomePageState();
}

class _HomePageState extends State<Budget> {
  Future<double> calculatingBudgetPercentage() async {
    // getting budget amount
    final budget = await firestore.collection('budget').get();
    double budgetAmount = 0;
    if (budget.docs.isNotEmpty) {
      for (var doc in budget.docs) {
        final data = doc.data();
        budgetAmount += data['amount'];
      }
      final expense = await firestore.collection('Transaction').get();
      double expenseAmount = 0;
      for (var doc in expense.docs) {
        final data = doc.data();
        if (data['type'] == 'expense') {
          expenseAmount += data['amount'] ?? 0;
        }
      }

      if (budgetAmount == 0) {
        return 0;
      } else {
        double percentage =
            ((budgetAmount - expenseAmount) / budgetAmount) * 100;
        return percentage;
      }
    }
    return 0;
  }

  var collection = FirebaseFirestore.instance.collection("budget");
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late List<BudgetModel> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            SliverAppBar(
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              expandedHeight: 170.0,
              floating: true,
              pinned: true,
              centerTitle: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Colors.blue,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 55,
                        child: FutureBuilder<double>(
                          future: calculatingBudgetPercentage(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text(
                                "Error: ${snapshot.error}",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 15),
                              );
                            } else if (snapshot.hasData) {
                              double percentage = snapshot.data!;
                              return Text(
                                "${percentage.toStringAsFixed(2)}%",
                                style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              );
                            } else {
                              return const Text(
                                "0%",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              );
                            }
                          },
                        ),
                      ),
                      const Text(
                        'from your budget',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: Colors.white),
          child: ListView(
            children: [
              const Text(
                'Your budget',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const ShowBudget(),
              const SizedBox(
                height: 20,
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
                    "Create new budget",
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
      ),
    );
  }
}
