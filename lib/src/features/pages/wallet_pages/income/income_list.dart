// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/src/constants/models/bank_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../constants/models/transaction_model.dart';

class IncomeList extends StatefulWidget {
  IncomeList({
    this.bank,
    this.transaction,
    super.key,
  });

  BanksModel? bank;
  TransactionModel? transaction;

  @override
  State<IncomeList> createState() => _IncomeListState();
}

class _IncomeListState extends State<IncomeList> {
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
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final transactions = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: false,
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final income = transactions[index];
                final transaction = TransactionModel.fromMap(income.data());
                return ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  leading: CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.blue[50],
                    child: const Icon(
                      size: 28,
                      Icons.account_balance_wallet,
                      color: Colors.blue,
                    ),
                  ),
                  title: Text(
                    // ''  "Wallet Balance",
                    transaction.transactionName!,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(transaction.date.toString(),
                      style:
                          TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                  trailing: Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontSize: 13,
                        color: transaction.type == "income"
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        const TextSpan(
                          text: '\$',
                        ),
                        TextSpan(
                          text: transaction.amount.toString(),
                        ),
                      ],
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
