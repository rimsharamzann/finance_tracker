// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/src/constants/models/bank_model.dart';
import 'package:finance_tracker/src/features/pages/wallet_pages/cashwallet/sliver_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _HomePageState();
}

class _HomePageState extends State<Wallet> {
  TextEditingController bankName = TextEditingController();
  TextEditingController accountNumber = TextEditingController();

  double calculateTotalBalance(
    List<QueryDocumentSnapshot> transactions,
  ) {
    double income = 0;
    double expense = 0;

    for (var doc in transactions) {
      final data = doc.data() as Map<String, dynamic>;

      if (data['type'] == 'income') {
        income += data['amount'] ?? 0;
      } else if (data['type'] == 'expense') {
        expense += data['amount'] ?? 0;
      }
    }
    return income - expense;
  }

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
                              "\$0",
                              // If no transactions, show zero balance
                              style:
                                  TextStyle(fontSize: 26, color: Colors.white),
                            );
                          }
                          // final bank = ModalRoute.of(context)
                          //     ?.settings
                          //     .arguments as BanksModel;
                          double availableBalance = calculateTotalBalance(
                            snapshot.data!.docs,
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
                      // Text(
                      //   // '\$440,182',
                      //   "\$${availableBalance.toString()}",
                      //
                      //   style: TextStyle(
                      //       fontSize: 28,
                      //       fontWeight: FontWeight.bold,
                      //       color: Colors.white),
                      // ),
                      const Text(
                        'Total Balance',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: Colors.white),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              const Text(
                'Your Wallets',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              BankDetails(),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => const BottomSheet(),
                        isScrollControlled: true,
                        scrollControlDisabledMaxHeightRatio: double.infinity,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        maximumSize:
                            Size(MediaQuery.of(context).size.width * 0.8, 70)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.add,
                            size: 12,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          'Link Bank Account',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BottomSheet extends StatefulWidget {
  const BottomSheet({super.key});

  @override
  State<BottomSheet> createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  TextEditingController bankName = TextEditingController();
  TextEditingController accountNumber = TextEditingController();

  Future<void> addBank(String bankName, double accountNumber) async {
    final bankId = randomAlphaNumeric(8);
    final bankDetails =
        FirebaseFirestore.instance.collection('banks').doc(bankId);

    final bankModel = BanksModel(
        uid: FirebaseAuth.instance.currentUser?.uid ?? '',
        bankId: bankId,
        bankName: bankName,
        accountNumber: accountNumber,
        amount: 0);

    await bankDetails.set(bankModel.toMap());
  }

  var collection = FirebaseFirestore.instance.collection("banks");
  late List<BanksModel> items;

  void onConfirm() async {
    if (bankName.text.isEmpty || accountNumber.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required!")),
      );
      return;
    }

    try {
      double accNum = double.parse(accountNumber.text);
      await addBank(bankName.text, accNum);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bank details added successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Bank Details",
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                  fontSize: 18),
            ),
            const SizedBox(
              height: 40,
            ),
            TextField(
              controller: bankName,
              decoration: InputDecoration(
                focusColor: Colors.grey.shade200,
                hintText: "Add Bank Name",
                hoverColor: Colors.grey.shade200,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: accountNumber,
              decoration: InputDecoration(
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                hintText: "Enter account number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  onConfirm();
                  // _getItems();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/wallet', (route) => false);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(10)),
                    maximumSize:
                        Size(MediaQuery.of(context).size.width * 0.5, 45)),
                child: const Text(
                  "Confirm",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}

class WalletCard extends StatelessWidget {
  final String title;
  final String balance;
  final VoidCallback onPressed;

  const WalletCard({
    super.key,
    required this.title,
    required this.balance,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(title),
              const SizedBox(height: 16),
              Text(balance),
              const Spacer(),
              ElevatedButton(
                onPressed: onPressed,
                child: const Text('Add Money'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
