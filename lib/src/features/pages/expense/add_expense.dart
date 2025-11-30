// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/src/constants/models/budget_model.dart';
import 'package:finance_tracker/src/features/pages/wallet_pages/category_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

import '../../../constants/models/bank_model.dart';
import '../../../constants/models/transaction_model.dart';

// ignore: must_be_immutable
class AddExpense extends StatefulWidget {
  AddExpense({super.key, required this.bank, this.budget});

  final BanksModel bank;
  BudgetModel? budget;

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  var collection = FirebaseFirestore.instance.collection("Transaction");
  late List<Map<String, dynamic>> items;

  int _categorySelectedIndex = 0;

  Future<void> addExpense(
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
      type: 'expense',
      categoryName: _categories[_categorySelectedIndex].name.toString(),
    );

    await transactionDetails.set(transactionModel.toMap());
  }

  void confirm() async {
    if (transactionName.text.isEmpty ||
        amount.text.isEmpty ||
        date.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required!")),
      );

      return;
    }

    try {
      double amounts = double.parse(amount.text);
      DateTime dates = DateTime.parse(date.text);
      await addExpense(
        transactionName.text,
        amounts,
        dates,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Transection details added successfully!")),
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
  TextEditingController date = TextEditingController();

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context, firstDate: DateTime.now(), lastDate: DateTime(2100));
    if (pickedDate != null) {
      setState(() {
        date.text = pickedDate.toString().split(" ")[0];
      });
    }
  }

  final List<CategoryModel> _categories = [
    CategoryModel(
      categoryId: 1,
      name: "Food and Drinks",
      image: "assets/images/img_13.png",
      color: Colors.pink.shade200,
    ),
    CategoryModel(
      categoryId: 2,
      name: "Shopping",
      image: "assets/images/img_12.png",
      color: Colors.pink.shade200,
    ),
    CategoryModel(
      categoryId: 3,
      name: "Entertainment",
      image: "assets/images/img_14.png",
      color: Colors.pink.shade200,
    ),
    CategoryModel(
      categoryId: 4,
      name: "Travel",
      image: "assets/images/img_13.png",
      color: Colors.greenAccent.shade200.withValues(alpha:  0.1),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Transaction')
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .where('bankId', isEqualTo: widget.bank.bankId)
            .snapshots(),
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Container(
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
                      const Text(
                        "Expense",
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w700,
                            fontSize: 18),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CategoryList(
                        onCategorySelect: (categoryIndex) {
                          // print(widget.budget?.categoryName);
                          setState(() {
                            _categorySelectedIndex = categoryIndex;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 45,
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: TextField(
                          controller: transactionName,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
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
                          controller: date,
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
                            //   _getomes();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadiusDirectional.circular(10)),
                              maximumSize: const Size(double.infinity, 60)),
                          child: const Text(
                            "Add Expense",
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
