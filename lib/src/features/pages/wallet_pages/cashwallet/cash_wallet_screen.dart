import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/src/constants/models/bank_model.dart';
import 'package:finance_tracker/src/features/pages/expense/add_expense.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart%20';

import '../income/adding_income.dart';
import '../income/income_list.dart';
import 'calender.dart';

// ignore: must_be_immutable
class CashWalletScreen extends StatefulWidget {
  CashWalletScreen({super.key, this.bank});

  BanksModel? bank;

  @override
  State<CashWalletScreen> createState() => _CashWalletScreenState();
}

class _CashWalletScreenState extends State<CashWalletScreen> {
  TextEditingController balance = TextEditingController();

  double calculateTotalBalance(
      List<QueryDocumentSnapshot> transactions, String bankId) {
    double income = 0;
    double expense = 0;

    for (var doc in transactions) {
      final data = doc.data() as Map<String, dynamic>;
      if (data['bankId'] == bankId) {
        if (data['type'] == 'income') {
          income += data['amount'] ?? 0;
        } else if (data['type'] == 'expense') {
          expense += data['amount'] ?? 0;
        }
      }
    }
    return income - expense;
  }

  @override
  Widget build(BuildContext context) {
    final bank = ModalRoute.of(context)?.settings.arguments as BanksModel;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              bank.bankName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              bank.accountNumber.toString(),
              style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Wrap(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor:
                                Colors.blue.shade100.withValues(alpha: 0.5),
                            child: Icon(
                              Icons.sync,
                              color: Colors.blue.shade700,
                            ),
                          ),
                          title: const Text(
                            'Sync Transaction',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87),
                          ),
                        ),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor:
                                Colors.red.shade100.withValues(alpha: 0.5),
                            child: Icon(
                              Icons.delete,
                              color: Colors.red.shade700,
                            ),
                          ),
                          title: GestureDetector(
                            onTap: () {
                              deleteTransation();
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Delete Wallet',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black87),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Icon(Icons.more_vert)),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 1,
                        spreadRadius: 2,
                        color: Colors.grey.shade50)
                  ],
                  border: Border.all(width: 1, color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 110,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('Transaction')
                                      .where('bankId',
                                          isEqualTo: widget.bank?.bankId)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    }

                                    if (snapshot.hasError ||
                                        !snapshot.hasData ||
                                        snapshot.data!.docs.isEmpty) {
                                      return const Text(
                                        " \$0",
                                        style: TextStyle(
                                            fontSize: 26, color: Colors.white),
                                      );
                                    }
                                    double availableBalance =
                                        calculateTotalBalance(
                                      snapshot.data!.docs,
                                      bank.bankId,
                                    );

                                    return Text(
                                      "\$${availableBalance.toString()}",
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "available balance",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: -35,
                            top: -40,
                            child: CircleAvatar(
                                radius: 40,
                                backgroundColor:
                                    Colors.white70.withValues(alpha: 0.1)),
                          ),
                          Positioned(
                            right: -25,
                            bottom: -40,
                            child: CircleAvatar(
                                radius: 38,
                                backgroundColor:
                                    Colors.white70.withValues(alpha: 0.15)),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            FirebaseFirestore.instance
                                .collection('Transaction')
                                .where('uid',
                                    isEqualTo:
                                        FirebaseAuth.instance.currentUser?.uid)
                                .where('bankId', isEqualTo: widget.bank?.bankId)
                                .snapshots();

                            showModalBottomSheet(
                              context: context,
                              builder: (context) => AddingIncome(
                                bank: bank,
                              ),
                              isScrollControlled: true,
                              scrollControlDisabledMaxHeightRatio:
                                  double.infinity,
                            );
                          },
                          child: const Text(
                            " Add Income",
                            style: TextStyle(fontSize: 12, color: Colors.blue),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          child: VerticalDivider(
                            width: 5,
                            thickness: 2,
                            color: Colors.blue.shade50,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            FirebaseFirestore.instance
                                .collection('Transaction')
                                .where('uid',
                                    isEqualTo:
                                        FirebaseAuth.instance.currentUser?.uid)
                                .where('bankId', isEqualTo: widget.bank?.bankId)
                                .snapshots();
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => AddExpense(
                                bank: bank,
                              ),
                              isScrollControlled: true,
                              scrollControlDisabledMaxHeightRatio:
                                  double.infinity,
                            );
                          },
                          child: const Text(
                            " Add Expense",
                            style: TextStyle(fontSize: 12, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Transactions Section
                  ],
                ),
              ),
            ),
            const Calender(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: Divider(
                  //  height: 10,
                  thickness: 1,
                  color: Colors.grey.shade200,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => AddingIncome(
                    bank: bank,
                  ),
                  isScrollControlled: true,
                  scrollControlDisabledMaxHeightRatio: double.infinity,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(
                    top: 0, bottom: 10, left: 15, right: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(width: 0.5, color: Colors.grey.shade200)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.blue.shade50,
                          child: const Icon(
                            Icons.add,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('Transaction')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }

                                  if (snapshot.hasError ||
                                      !snapshot.hasData ||
                                      snapshot.data!.docs.isEmpty) {
                                    return const Text(
                                      r"$0",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    );
                                  }
                                  double availableBalance =
                                      calculatingBankIncome(
                                          snapshot.data!.docs, bank);

                                  return Text(
                                    "\$${availableBalance.toString()}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }),

                            // Text(widget.money,
                            //     style: const TextStyle(
                            //         color: Colors.black87,
                            //         fontSize: 15,
                            //         fontWeight: FontWeight.bold)),
                            Text("Income",
                                style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                      child: VerticalDivider(
                        width: 10,
                        thickness: 1.5,
                        color: Colors.grey.shade100,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => AddExpense(
                            bank: bank,
                          ),
                          isScrollControlled: true,
                          scrollControlDisabledMaxHeightRatio: double.infinity,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.red.shade50,
                            child: const Icon(
                              Icons.remove,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('Transaction')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }

                                  if (snapshot.hasError ||
                                      !snapshot.hasData ||
                                      snapshot.data!.docs.isEmpty) {
                                    return const Text(
                                      r"$0",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    );
                                  }
                                  double availableBalance =
                                      calculatingBankExpense(
                                          snapshot.data!.docs, bank);

                                  return Text(
                                    "\$${availableBalance.toString()}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),

                              // Text(widget.money,
                              //     style: const TextStyle(
                              //         color: Colors.black87,
                              //         fontSize: 15,
                              //         fontWeight: FontWeight.bold)),
                              Text("Expense",
                                  style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 250,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),

                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      axisNameSize: 10,
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text(
                                '\$0',
                                style: TextStyle(fontSize: 12),
                              );
                            case 3:
                              return const Text(
                                "\$500",
                                style: TextStyle(fontSize: 12),
                              );
                            case 6:
                              return const Text(
                                '\$1000',
                                style: TextStyle(fontSize: 8),
                              );
                            case 9:
                              return const Text(
                                '\$2000',
                                style: TextStyle(fontSize: 8),
                              );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                              (value.toInt() + 1).toString().padLeft(2, '0'));
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.transparent),
                  ),

                  // Line chart data
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 1),
                        const FlSpot(1, 2),
                        const FlSpot(2, 6),
                        const FlSpot(3, 4),
                        const FlSpot(4, 5),
                        const FlSpot(5, 5),
                        const FlSpot(6, 7),
                        const FlSpot(7, 4),
                      ],
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.withValues(alpha: 0.1),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],

                  // Chart range
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 9,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  textAlign: TextAlign.start,
                  "Transactions",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: IncomeList(
                bank: bank,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String selectedType = "income";

  double calculatingBankIncome(
      List<QueryDocumentSnapshot> transactions, BanksModel? bank) {
    double income = 0;
    for (var doc in transactions) {
      final data = doc.data() as Map<String, dynamic>;
      if (data['bankId'] == bank?.bankId) {
        if (data['type'] == 'income') {
          income += data['amount'] ?? 0;
        }
      }
    }
    return income;
  }

  double calculatingBankExpense(
      List<QueryDocumentSnapshot> transactions, BanksModel? bank) {
    double expense = 0;
    for (var doc in transactions) {
      final data = doc.data() as Map<String, dynamic>;
      if (data['bankId'] == bank?.bankId) {
        if (data['type'] == 'expense') {
          expense += data['amount'] ?? 0;
        }
      }
    }
    return expense;
  }

  Future<void> deleteTransation() async {
    final trans = FirebaseFirestore.instance.collection('Transaction');
// var transaction = TransactionModel.fromMap(DocumentSnapshot.data() as Map<String, dynamic>);
    try {
      final query = await trans.get();

      for (QueryDocumentSnapshot doc in query.docs) {
        await trans.doc(doc.id).delete();
      }
    } catch (e) {
      [];
    }
  }
}
