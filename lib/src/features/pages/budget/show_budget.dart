import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/src/features/pages/wallet_pages/transactions/transaction_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart%20';

import '../../../constants/models/budget_model.dart';

class ShowBudget extends StatefulWidget {
  const ShowBudget({super.key});

  @override
  State<ShowBudget> createState() => _ShowBudgetState();
}

class _ShowBudgetState extends State<ShowBudget> {
 var collection = FirebaseFirestore.instance.collection("budget");

  

  late List<BudgetModel> items;

  double calculatingSpentAmount(
      List<QueryDocumentSnapshot> transactions, BudgetModel budget) {
    double budgetAmount = budget.amount;
    // print(budgetAmount);

    for (var doc in transactions) {
      final data = TransactionModel.fromMap(doc.data() as Map<String, dynamic>);
      // print(data.amount);
      budgetAmount = budgetAmount - data.amount;
    }
    return budgetAmount;
    // return spendAmount;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('budget')
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return SizedBox(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: streamSnapshot.data?.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  final budget = BudgetModel.fromMap(
                      documentSnapshot.data() as Map<String, dynamic>);

                  return Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border:
                            Border.all(width: 1, color: Colors.grey.shade100),
                        color: Colors.white),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.account_balance,
                              size: 40, color: Colors.blue),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  // 'Food and drinks',
                                  budget.categoryName,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Expanded(
                                      child: StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('Transaction')
                                            .where('uid',
                                                isEqualTo: FirebaseAuth
                                                    .instance.currentUser?.uid)
                                            .where('type', isEqualTo: 'expense')
                                            .where('categoryName',
                                                isEqualTo: budget.categoryName)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            final expenseList =
                                                snapshot.data?.docs ?? [];
                                            final leftAmount =
                                                calculatingSpentAmount(
                                                    expenseList, budget);
                                            return LinearProgressIndicator(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              value: (((budget.amount -
                                                              leftAmount) /
                                                          budget.amount) *
                                                      100) /
                                                  100,
                                              backgroundColor: Colors.grey[300],
                                              valueColor:
                                                  const AlwaysStoppedAnimation<
                                                      Color>(
                                                Colors.red,
                                              ),
                                            );
                                          }
                                          return const SizedBox.shrink();
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      // '\$675'
                                      budget.amount.toString(),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('Transaction')
                                      .where('uid',
                                          isEqualTo: FirebaseAuth
                                              .instance.currentUser?.uid)
                                      .where('type', isEqualTo: 'expense')
                                      .where('categoryName',
                                          isEqualTo: budget.categoryName)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final expenseList =
                                          snapshot.data?.docs ?? [];
                                      final leftAmount = calculatingSpentAmount(
                                          expenseList, budget);
                                      return Text.rich(
                                        TextSpan(children: [
                                          TextSpan(
                                            text: leftAmount.toString(),
                                            style: TextStyle(
                                                color: Colors.grey[600]),
                                          ),
                                          TextSpan(
                                              text: " left to use",
                                              style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 12))
                                        ]),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return const CircularProgressIndicator();
        });
  }
}
