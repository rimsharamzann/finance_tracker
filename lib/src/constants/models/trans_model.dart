import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class TransModel {
  String? uid;
  String? bankId;
  String? transactionName;
  double? tAmount;
  DateTime? date;
  IconData? iconData;

  TransModel({
    required this.uid,
    this.bankId,
    this.tAmount,
    this.iconData,
    this.date,
    this.transactionName,
  });

  Map<String, dynamic> toMap() {
    // ignore: prefer_typing_uninitialized_variables
    var transactionName;
    return {
      "uid": uid,
      "bankId": bankId,
      "iconData": iconData,
      'date': date,
      'transactionName': transactionName,
      'tAmount': tAmount,
    };
  }

  factory TransModel.fromMap(Map<String, dynamic> map) {
    return TransModel(
      uid: FirebaseAuth.instance.currentUser?.uid ?? "",
      bankId: map["bankId"] ?? '',
      transactionName: map['transactionName'] ?? "",
      iconData: map["iconData"],
      date: map['date'],
      tAmount: map['tAmount'],
    );
  }
}
