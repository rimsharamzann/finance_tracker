import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart%20';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Transactions",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: CircleAvatar(
              backgroundColor: Colors.green[50],
              child: const Icon(
                Icons.account_balance_wallet,
                color: Colors.green,
              ),
            ),
            title: const Text(
              "Wallet Balance",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            subtitle: Text(
              "Today",
              style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
            ),
            trailing: const Text(
              "+\$1,820",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const IncomeList(),
        ],
      ),
    );
  }
}

class TransactionModel {
  String? uid;
  String? bankId;
  String transactionName;
  double amount;
  DateTime date;
  String type;

  TransactionModel({
    this.uid,
    this.bankId,
    required this.transactionName,
    required this.amount,
    required this.date,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "bankId": bankId,
      'transactionName': transactionName,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      uid: FirebaseAuth.instance.currentUser?.uid ?? '',
      bankId: map["bankId"] as String,
      transactionName: map['transactionName'] as String,
      amount: map['amount'] as double,
      date: DateTime.parse((map['date'] as Timestamp).toDate().toString()),
      type: map['type'] as String,
    );
  }
}

class IncomeList extends StatefulWidget {
  const IncomeList({super.key});

  @override
  State<IncomeList> createState() => _IncomeListState();
}

late List<Map<String, dynamic>> items;

class _IncomeListState extends State<IncomeList> {
  Future<void> updateTransaction(String transactionId, String type) async {
    if (type.isEmpty || type != 'income' && type != 'expense') {
      throw Exception('Invalid transaction type');
    }

    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore.collection('transaction').doc(transactionId).update({
      'type': type,
    });
  }

  bool checkType = false;

  Stream<List<TransactionModel>> fetchIncomes() {
    return FirebaseFirestore.instance
        .collection('incomes')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TransactionModel.fromMap(doc.data());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: StreamBuilder<List<TransactionModel>>(
        stream: fetchIncomes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          //   return Center(child: Text('No incomes added yet.'));
          // }
          else {
            final incomes = snapshot.data!;

            return checkType
                ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: false,
                    itemCount: incomes.length,
                    itemBuilder: (context, index) {
                      final income = TransactionModel.fromMap(
                          snapshot.data! as Map<String, dynamic>);
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
                          income.transactionName,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                        subtitle: Text(
                          //  "Today",
                          income.date.toString(),
                          style: TextStyle(
                              fontSize: 10, color: Colors.grey.shade500),
                        ),
                        trailing: Text(
                          //  "+\$1,820",
                          income.amount.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: false,
                    itemCount: incomes.length,
                    itemBuilder: (context, index) {
                      final income = incomes[index];
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
                          income.transactionName,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                        subtitle: Text(
                          //  "Today",
                          income.date.toString(),
                          style: TextStyle(
                              fontSize: 10, color: Colors.grey.shade500),
                        ),
                        trailing: Text(
                          //  "+\$1,820",
                          income.amount.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green.shade700,
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
