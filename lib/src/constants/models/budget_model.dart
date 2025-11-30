import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BudgetModel {
  String uid;

  // String bankId;
  String categoryName;

  double amount;
  double spendAmount;
  DateTime date;

  BudgetModel({
    required this.uid,
    // required this.bankId,
    required this.categoryName,
    required this.date,
    this.spendAmount = 120,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      // 'bankId': bankId,
      'categoryName': categoryName,
      'date': date,
      'amount': amount,
      'spendAmount': spendAmount,
    };
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      uid: FirebaseAuth.instance.currentUser?.uid ?? "",
      date: (map['date'] as Timestamp).toDate(),
      categoryName: map["categoryName"] ?? '',
      amount: map['amount'] != null ? (map['amount'] as num).toDouble() : 0.0,
      spendAmount: map['spendAmount'] != null
          ? (map['spendAmount'] as num).toDouble()
          : 0.0,
    );
  }
}

class CategoryModel {
  final String name;
  final num categoryId;
  final String image;
  final Color color;

  CategoryModel({
    required this.categoryId,
    required this.name,
    required this.image,
    required this.color,
  });
}
