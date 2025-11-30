// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/src/constants/models/transaction_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart%20';

import '../../../constants/models/budget_model.dart';
import '../wallet_pages/category_list.dart';

// ignore: must_be_immutable
class CreateBudget extends StatefulWidget {
  TransactionModel? transaction;

  CreateBudget({
    super.key,
  });

  @override
  State<CreateBudget> createState() => _CreateBudgetState();
}

class _CreateBudgetState extends State<CreateBudget> {
  TextEditingController amountController = TextEditingController();
  final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);

  var collection = FirebaseFirestore.instance.collection("budget");
  int _selectedCategoryIndex = 0;

  Future<void> saveBudget() async {
    final categoryName = categories[_selectedCategoryIndex].name;

    if (amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a category and enter an amount"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newAmount = double.parse(amountController.text);

    try {
      final budgets = await FirebaseFirestore.instance
          .collection('budget')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();

      final categoryAlreadyExist = budgets.docs.any((e) {
        final singleBudget = BudgetModel.fromMap(e.data());
        return singleBudget.categoryName == categoryName;
      });

      if (categoryAlreadyExist) {
        final existedBudget = budgets.docs.firstWhere((e) {
          final singleBudget = BudgetModel.fromMap(e.data());
          return singleBudget.categoryName == categoryName;
        });

        final currentAmount = BudgetModel.fromMap(existedBudget.data()).amount;

        final updatedAmount = currentAmount + newAmount;

        final updatedBudgetModel = BudgetModel(
          uid: FirebaseAuth.instance.currentUser?.uid ?? '',
          amount: updatedAmount,
          categoryName: categoryName,
          date: DateTime.now(),
        );

        await FirebaseFirestore.instance
            .collection('budget')
            .doc(existedBudget.id)
            .update(updatedBudgetModel.toMap());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Budget details updated successfully!"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
        return;
      }

      final budgetModel = BudgetModel(
        uid: FirebaseAuth.instance.currentUser?.uid ?? '',
        amount: newAmount,
        categoryName: categoryName,
        date: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('budget')
          .add(budgetModel.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Budget details added successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context); // Navigate back
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
      rethrow;
    }
  }

  static String? get userId => FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('budget')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots();
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              0, 20, 0, 20 + MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 40,
                child: Divider(
                  height: 5,
                  thickness: 2,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CategoryList(
                onCategorySelect: (categoryIndex) {
                  setState(() {
                    _selectedCategoryIndex = categoryIndex;
                  });
                  // print("selected Category index: $_selectedCategoryIndex");
                },
              ),
              const SizedBox(
                height: 0,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                child: SizedBox(
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintStyle:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                        hintText: "Enter Monthly amount",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(8),
                        )),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        saveBudget();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadiusDirectional.circular(10)),
                          maximumSize: const Size(double.infinity, 50)),
                      child: const Text(
                        "Create Budget",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
