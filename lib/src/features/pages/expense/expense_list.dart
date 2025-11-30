import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants/models/bank_model.dart';
import '../../../constants/models/transaction_model.dart';

// ignore: must_be_immutable
class ExpenseList extends StatefulWidget {
  ExpenseList({
    this.bank,
    this.transaction,
    super.key,
  });

  BanksModel? bank;
  TransactionModel? transaction;

  @override
  State<ExpenseList> createState() => _IncomeListState();
}

class _IncomeListState extends State<ExpenseList> {
  TransactionModel? transaction;
  String selectedType = "income";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Transaction')
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .where('bankId', isEqualTo: widget.bank?.bankId)
            .where('type', isEqualTo: widget.transaction?.type == "expense")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final transactions = snapshot.data!.docs;
            // print(' Expense transaction list: $transactions');

            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: false,
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final expense = transactions[index];
                final transaction = TransactionModel.fromMap(expense.data());
                return ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  leading: CircleAvatar(
                    backgroundColor: Colors.green[50],
                    child: const Icon(
                      Icons.account_balance_wallet,
                      color: Colors.green,
                    ),
                  ),
                  title: Text(
                    // ''  "Wallet Balance",
                    transaction.transactionName.toString(),
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                  subtitle: Text(
                    //  "Today",
                    transaction.date.toString(),
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                  ),
                  trailing: Text(
                    transaction.amount.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      color: transaction.type == "expense"
                          ? Colors.red
                          : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
