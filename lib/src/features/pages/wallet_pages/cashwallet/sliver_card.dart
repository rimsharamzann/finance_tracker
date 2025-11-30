// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart%20';

import '../../../../constants/models/bank_model.dart';

// ignore: must_be_immutable
class BankDetails extends StatefulWidget {
  BankDetails({super.key, this.bank});

  BanksModel? bank;

  @override
  State<BankDetails> createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  var collection = FirebaseFirestore.instance.collection("banks");
  List<BanksModel> items = [];
  bool _isLoaded = false;
  bool isEmpty = false;

  Future<void> _getItems() async {
    late List<BanksModel> tempList = [];
    var data = await collection.get(
        // GetOptions(serverTimestampBehavior: ServerTimestampBehavior.none)
        );

    // ignore: no_leading_underscores_for_local_identifiers
    for (var _element in data.docs) {
      tempList.add(BanksModel.fromDocument(_element));
    }
    setState(() {
      items = tempList;
      _isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _getItems();
  }

  Future<double?> updateAmount(
      List<QueryDocumentSnapshot> Transaction, BanksModel? bank) async {
    double bankAmount = 0;
    double income = 0;
    double expense = 0;

    for (var doc in Transaction) {
      final data = doc.data() as Map<String, dynamic>;
      if (data['bankId'] == bank?.bankId) {
        if (data['type'] == 'income') {
          income += data['amount'] ?? 0;
        } else if (data['type'] == 'expense') {
          expense = data['amount'] + expense ?? 0;
        }
        bankAmount = income - expense;
        var banks = await FirebaseFirestore.instance
            .collection('banks')
            .where('bankId', isEqualTo: bank?.bankId)
            .get();
        try {
          if (banks.docs.isNotEmpty) {
            for (var bankDoc in banks.docs) {
              await bankDoc.reference.update({
                'amount': bankAmount,
              });
            }
          }
        } catch (e) {
          [];
        }
      }
    }
    return bankAmount;
  }

  double updatingBankAmount(
    List<QueryDocumentSnapshot> Transactions,
    BanksModel? bank,
  ) {
    double totalAmount = 0;

    // print(Transactions);

    for (var doc in Transactions) {
      final data = doc.data() as Map<String, dynamic>;
      if (data['type'] == 'income') {
        totalAmount = totalAmount + (data['amount'] ?? 0);
        // print(income);
      } else if (data['type'] == 'expense') {
        totalAmount = totalAmount - (data['amount'] ?? 0);
        // print(expense);
      }

      updateAmount(Transactions, bank);
    }
    // print(income);
    return totalAmount;
  }

  @override
  Widget build(BuildContext context) {
    //
    return _isLoaded
        ? ListView.builder(
            itemCount: items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final bank = items[index];
              // final banks = ModalRoute.of(context)?.settings.arguments as BanksModel;

              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // print('--------');
                      Navigator.of(context).pushNamed("/cash", arguments: bank);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 1,
                                spreadRadius: 2,
                                color: Colors.grey.shade50)
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            width: 2,
                            color: Colors.grey.shade100,
                          )),
                      margin: const EdgeInsets.only(
                          top: 12, bottom: 12, right: 0, left: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.orange.shade100,
                                //Colors.orange.shade100,
                                child: const CircleAvatar(
                                    radius: 15,
                                    backgroundImage:
                                        AssetImage("assets/images/img_17.png")),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bank.bankName,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(bank.accountNumber.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11,
                                          color: Colors.grey.shade500)),
                                ],
                              )
                            ],
                          ),
                          Divider(
                            height: 30,
                            thickness: 1,
                            color: Colors.grey.shade50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('Transaction')
                                    .where('bankId', isEqualTo: bank.bankId)
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

                                  // print(snapshot.data?.docs);

                                  return Text(
                                    "\$${updatingBankAmount(snapshot.data!.docs, bank).toString()}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                                color: Colors.grey,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          )
        : const SizedBox(
            height: 20,
            width: 20,
          );
  }
}
