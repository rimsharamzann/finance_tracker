// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/src/constants/models/bank_model.dart';
import 'package:finance_tracker/src/constants/models/budget_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart%20';
import 'package:random_string/random_string.dart';

import '../../../../constants/models/transaction_model.dart';

// ignore: must_be_immutable
class AddingIncome extends StatefulWidget {
  AddingIncome({super.key, required this.bank, this.budget});

  final BanksModel bank;
  BudgetModel? budget;

  @override
  State<AddingIncome> createState() => _AddingIncomeState();
}

class _AddingIncomeState extends State<AddingIncome> {
  var collection = FirebaseFirestore.instance.collection("Transaction");
  late List<Map<String, dynamic>> items;

  Future<void> addIncome(
      String transactionName, double amount, DateTime date) async {
    final tid = randomAlphaNumeric(8);
    final transactionDetails =
        FirebaseFirestore.instance.collection('Transaction').doc(tid);

    final transactionModel = TransactionModel(
        uid: FirebaseAuth.instance.currentUser?.uid ?? '',
        bankId: widget.bank.bankId,
        transactionName: transactionName,
        date: date,
        amount: amount,
        type: 'income',
        categoryName: widget.budget?.categoryName ?? "Food and Drinks");

    await transactionDetails.set(transactionModel.toMap());
  }

  void confirm() async {
    if (transactionName.text.isEmpty || amount.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required!")),
      );
      if (dateController.text.isEmpty) {
        setState(() {
          dateController.text = DateTime.now().toString();
        });
      } else {
        dateController.text = dateController.toString().split("")[1];
      }

      return;
    }

    try {
      double amounts = double.parse(amount.text);
      DateTime dates = DateTime.parse(dateController.text);
      await addIncome(
        transactionName.text,
        amounts,
        dates,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Transection details  added successfully!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  TextEditingController transactionName = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController dateController = TextEditingController();

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context, firstDate: DateTime.now(), lastDate: DateTime(2100));
    if (pickedDate != null) {
      setState(() {
        dateController.text = DateTime.now().toString();
      });
    } else {
      dateController.text = pickedDate.toString().split("")[1];
    }
  }

  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore.instance
    //     .collection('Transaction')
    //     .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
    //     .where('bankId', isEqualTo: widget.bank.bankId)
    //     .snapshots();

    // final income =
    //     ModalRoute.of(context)?.settings.arguments as TransactionModel;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Transaction')
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .where('bankId', isEqualTo: widget.bank.bankId)
            .snapshots(),
        builder: (context, snapshot) {
          // final transaction = TransactionModel.fromMap(income.data());

          // final transactions = snapshot.data!.docs;

          return SingleChildScrollView(
            child: Container(
              // height: MediaQuery.of(context).size.height * 0.65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    20, 20, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 50,
                        child: Divider(
                          height: 5,
                          thickness: 3,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.blue.shade50,
                        child: Container(
                          width: 110,
                          height: 110,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset(
                            "assets/images/img_8.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "Income",
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w700,
                            fontSize: 18),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        height: 45,
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: TextField(
                          controller: transactionName,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              // suffixIcon: Icon(Icons.numbers),
                              // suffixIconColor: Colors.grey.shade200,
                              hintStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                              label: const Text("Transaction Name"),
                              labelStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade200),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade200),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade200),
                                borderRadius: BorderRadius.circular(8),
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        height: 45,
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: TextField(
                          controller: amount,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              // suffixIcon: Icon(Icons.numbers),
                              // suffixIconColor: Colors.grey.shade200,
                              hintStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                              label: const Text("Amount"),
                              labelStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade200),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade200),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade200),
                                borderRadius: BorderRadius.circular(8),
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        height: 45,
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: TextField(
                          onTap: () {
                            _selectDate();
                          },
                          controller: dateController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              suffixIcon:
                                  const Icon(Icons.calendar_today_outlined),
                              suffixIconColor: Colors.blue,
                              label: const Text("Date"),
                              labelStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade200),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade200),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade200),
                                borderRadius: BorderRadius.circular(8),
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            confirm();
                            //   _getItems();
                            // fetchIncomes();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadiusDirectional.circular(10)),
                              maximumSize: const Size(double.infinity, 60)),
                          child: const Text(
                            "Add Income",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          );
        });
  }
}

class Money extends StatelessWidget {
  const Money(
      {super.key,
      required this.money,
      required this.text,
      required this.icon,
      required this.color,
      required this.bgc});

  final String money;

  final Color color;
  final Color bgc;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: bgc,
          child: Icon(
            icon,
            color: color,
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
            Text(money,
                style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
            Text(text,
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
    );
  }
}
