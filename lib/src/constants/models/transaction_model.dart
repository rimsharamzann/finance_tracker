import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionModel {
  String? uid;
  String? bankId;
  String? transactionName;
  double? amount;
  String categoryName;
  DateTime? date;
  String type;

  TransactionModel({
    this.uid,
    this.bankId,
    this.transactionName,
    this.amount,
    this.date,
    required this.categoryName,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "bankId": bankId,
      'transactionName': transactionName,
      'amount': amount,
      'categoryName': categoryName,
      'type': type,
      'date': date != null ? Timestamp.fromDate(date!) : null,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      uid: FirebaseAuth.instance.currentUser?.uid ?? '',
      bankId: map["bankId"] ?? '',
      transactionName: map['transactionName'] ?? '',
      amount: map['amount'] != null ? (map['amount'] as num).toDouble() : 0.0,
      type: map['type'] ?? "income",
      date: map['date'] is Timestamp
          ? (map['date'] as Timestamp).toDate()
          : DateTime.tryParse(map['date'] as String),
      categoryName: map['categoryName'] ?? "",
    );
  }
}
