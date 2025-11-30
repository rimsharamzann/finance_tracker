import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/src/features/pages/home/transections.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../wallet_pages/income/income_list.dart';
import 'sliver_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  // BanksModel? bank;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ref = FirebaseFirestore.instance.collection('Transaction');

  String _selectedMonth = 'January';
  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  double balance = 0;

  // final bank = ModalRoute.of(context)?.settings.arguments as BanksModel;

  double calculateTotalBalance(
    List<QueryDocumentSnapshot> transactions,
  ) {
    double income = 0;
    double expense = 0;

    for (var doc in transactions) {
      final data = doc.data() as Map<String, dynamic>;
      // if (data['bankId'] == bankId) {
      if (data['type'] == 'income') {
        income += data['amount'] ?? 0;
      } else if (data['type'] == 'expense') {
        expense += data['amount'] ?? 0;
      }
    }
    return income - expense;
  }

  double calculatingTotalIncome(
    List<QueryDocumentSnapshot> transactions,
  ) {
    double income = 0;

    for (var doc in transactions) {
      final data = doc.data() as Map<String, dynamic>;
      if (data['type'] == 'income') {
        income += data['amount'] ?? 0;
      }
    }
    return income;
  }

  double calculatingTotalExpense(
    List<QueryDocumentSnapshot> transactions,
  ) {
    double expense = 0;

    for (var doc in transactions) {
      final data = doc.data() as Map<String, dynamic>;
      if (data['type'] == 'expense') {
        expense += data['amount'] ?? 0;
      }
    }
    return expense;
  }

  @override
  Widget build(BuildContext context) {
    // final bank = ModalRoute.of(context)?.settings.arguments as BanksModel;

    return Scaffold(
      backgroundColor: Colors.blue,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            SliverAppBar(
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              expandedHeight: 280.0,
              floating: true,
              pinned: true,
              centerTitle: true,
              title: Container(
                height: 28,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white, width: 0.5)),
                child: DropdownButton(
                  dropdownColor: Colors.grey.shade500,
                  focusColor: Colors.blue,
                  underline: Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 0, color: Colors.transparent)),
                  ),

                  // padding: EdgeInsets.all(6),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  iconSize: 20,
                  iconEnabledColor: Colors.white,
                  value: _selectedMonth,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedMonth = newValue!;
                    });
                  },
                  items: _months.map((month) {
                    return DropdownMenuItem(
                      alignment: Alignment.center,
                      value: month,
                      child: Text(
                        month,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    );
                  }).toList(),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                    color: Colors.blue,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 110,
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Transaction')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator(
                                color: Colors.white,
                              );
                            }

                            if (snapshot.hasError ||
                                !snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return const Text(
                                r"$0",
                                style: TextStyle(
                                    fontSize: 26,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              );
                            }
                            double availableBalance = calculateTotalBalance(
                              snapshot.data!.docs,
                            );

                            return Text(
                              "\$${availableBalance.toString()}",
                              style: const TextStyle(
                                  fontSize: 26,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            );
                          },
                        ),

                        // const Text(
                        //   '\$24,012',
                        //   style: TextStyle(
                        //       fontSize: 26,
                        //       fontWeight: FontWeight.bold,
                        //       color: Colors.white),
                        // ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          'Monthly cash flow',
                          style: TextStyle(color: Colors.white70, fontSize: 10),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  width: 0.5, color: Colors.white30)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
// showing Income
                              GestureDetector(
                                // onTap: () {
                                //   showModalBottomSheet(
                                //     context: context,
                                //     builder: (context) => AddingIncome(
                                //       bank: bank,
                                //     ),
                                //     isScrollControlled: true,
                                //     scrollControlDisabledMaxHeightRatio:
                                //         double.infinity,
                                //   );
                                // },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.blue,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('Transaction')
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const CircularProgressIndicator(
                                                color: Colors.white,
                                              );
                                            }

                                            if (snapshot.hasError ||
                                                !snapshot.hasData ||
                                                snapshot.data!.docs.isEmpty) {
                                              return const Text(
                                                r"$0",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white),
                                              );
                                            }
                                            double availableBalance =
                                                calculatingTotalIncome(
                                              snapshot.data!.docs,
                                            );

                                            return Text(
                                              "\$${availableBalance.toString()}",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            );
                                          },
                                        ),
                                        const Text("Income",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8)),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(
                                height: 40,
                                child: VerticalDivider(
                                  thickness: 0.3,

                                  // width: 0.2,
                                  color: Colors.white,
                                ),
                              ),
                              // showing Expense
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                //  crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('Transaction')
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator(
                                              color: Colors.white,
                                            );
                                          }

                                          if (snapshot.hasError ||
                                              !snapshot.hasData ||
                                              snapshot.data!.docs.isEmpty) {
                                            return const Text(
                                              r"$0",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            );
                                          }
                                          double availableBalance =
                                              calculatingTotalExpense(
                                            snapshot.data!.docs,
                                          );

                                          return Text(
                                            "\$${availableBalance.toString()}",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        },
                                      ),
                                      const Text("Expense",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 8)),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
              ),
            ),
          ];
        },
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Transaction')
              .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            return snapshot.hasData
                ? Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        color: Colors.white),
                    child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 0),
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                            left: 20,
                            top: 10,
                            bottom: 0,
                          ),
                          child: Text(
                            'Spend Analysis',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SliverCard(),
                        const SizedBox(
                          height: 10,
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                          child: Text(
                            'Transactions',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
                            child: IncomeList()),
                      ],
                    ),
                  )
                : Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        color: Colors.white),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            "Transactions",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Transac(),
                      ],
                    ));
          },
        ),
      ),
    );
  }
}
