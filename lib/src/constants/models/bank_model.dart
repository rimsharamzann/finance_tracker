// // import 'dart:core';
// //
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart%20';
// //
// // class BankModel extends StatefulWidget {
// //   const BankModel({super.key});
// //
// //   @override
// //   State<BankModel> createState() => _BankModelState();
// // }
// //
// // class _BankModelState extends State<BankModel> {
// //   Future<List<BanksModel>> banks() async {
// //     final querySnapshot =
// //         await FirebaseFirestore.instance.collection('banks').get();
// //
// //     return querySnapshot.docs
// //         .map((doc) => BanksModel.fromDocument(doc))
// //         .toList();
// //   }
// //
// //   Future<void> addBank(BanksModel bank) async {
// //     await FirebaseFirestore.instance.collection('banks').add(bank.toMap());
// //   }
// //
// //   var collection = FirebaseFirestore.instance.collection("banks");
// //   late List<Map<String, dynamic>> items;
// //   bool _isLoaded = false;
// //   bool isEmpty = false;
// //
// //   void checkBalance() {
// //     final amount = FirebaseFirestore.instance.collection('banks').doc('amount');
// //
// //     if (amount.toString() == "") {
// //       setState(() {
// //         isEmpty = true;
// //       });
// //     }
// //     return null;
// //   }
// //
// //   _getItems() async {
// //     late List<Map<String, dynamic>> tempList = [];
// //     var data = await collection.get();
// //
// //     data.docs.forEach((_element) {
// //       tempList.add(_element.data());
// //     });
// //     setState(() {
// //       items = tempList;
// //       _isLoaded = true;
// //     });
// //   }
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _getItems();
// //   }
// //
// //   Stream<List<BanksModel>> fetchBanks() {
// //     return FirebaseFirestore.instance
// //         .collection('banks')
// //         .snapshots()
// //         .map((snapshot) {
// //       return snapshot.docs.map((doc) {
// //         return BanksModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
// //       }).toList();
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return _isLoaded
// //         ? ListView.builder(
// //             itemCount: items.length,
// //             shrinkWrap: true,
// //             physics: NeverScrollableScrollPhysics(),
// //             itemBuilder: (context, snapShot) {
// //               // late var bank = BanksModel.get(
// //               //     FirebaseFirestore.instance.collection("banks"));
// //
// //               return Container(
// //                 padding: const EdgeInsets.all(10),
// //                 decoration: BoxDecoration(
// //                     boxShadow: [
// //                       BoxShadow(
// //                           blurRadius: 1,
// //                           spreadRadius: 2,
// //                           color: Colors.grey.shade50)ad
// //                     ],
// //                     color: Colors.white,
// //                     borderRadius: BorderRadius.circular(15),
// //                     border: Border.all(
// //                       width: 2,
// //                       color: Colors.grey.shade100,
// //                     )),
// //                 margin: const EdgeInsets.only(
// //                     top: 12, bottom: 12, right: 0, left: 0),
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     Row(
// //                       //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                       children: [
// //                         CircleAvatar(
// //                           radius: 28,
// //                           backgroundColor: Colors.orange.shade100,
// //                           //Colors.orange.shade100,
// //                           child: const CircleAvatar(
// //                               radius: 15,
// //                               backgroundImage:
// //                                   AssetImage("assets/images/img_17.png")),
// //                         ),
// //                         const SizedBox(
// //                           width: 7,
// //                         ),
// //                         Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             const Text(
// //                               style: TextStyle(
// //                                 fontSize: 13,
// //                                 fontWeight: FontWeight.w600,
// //                               ),
// //                               // banks[index]["bankName"]
// //
// //                               "",
// //                             ),
// //                             Text("",
// //                                 style: TextStyle(
// //                                     fontWeight: FontWeight.w500,
// //                                     fontSize: 11,
// //                                     color: Colors.grey.shade500)),
// //                           ],
// //                         )
// //                       ],
// //                     ),
// //                     Divider(
// //                       height: 30,
// //                       thickness: 1,
// //                       color: Colors.grey.shade50,
// //                     ),
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         const Text("",
// //                             style: TextStyle(
// //                                 fontSize: 16, fontWeight: FontWeight.bold)),
// //                         GestureDetector(
// //                           child: const Icon(
// //                             Icons.arrow_forward_ios,
// //                             size: 18,
// //                             color: Colors.grey,
// //                           ),
// //                         )
// //                       ],
// //                     ),
// //                     SizedBox(
// //                       height: 12,
// //                     ),
// //                   ],
// //                 ),
// //               );
// //             })
// //         : _SpendCategory(
// //             "bank alflah",
// //             12334467,
// //           );
// //   }
// // }
// //
// // Widget _SpendCategory(
// //   String bankName,
// //   double accountNumber,
// // ) {
// //   return Container(
// //     padding: const EdgeInsets.all(10),
// //     decoration: BoxDecoration(
// //       boxShadow: [
// //         BoxShadow(blurRadius: 1, spreadRadius: 2, color: Colors.grey.shade50)
// //       ],
// //       color: Colors.white,
// //       borderRadius: BorderRadius.circular(15),
// //       border: Border.all(
// //         width: 2,
// //         color: Colors.grey.shade100,
// //       ),
// //     ),
// //     margin: const EdgeInsets.only(top: 12, bottom: 12, right: 0, left: 0),
// //     child: Column(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         Row(
// //           children: [
// //             CircleAvatar(
// //               radius: 28,
// //               backgroundColor: Colors.orange.shade50,
// //               child: CircleAvatar(
// //                 radius: 15,
// //                 backgroundColor: Colors.orange.shade50,
// //                 child: Icon(Icons.money),
// //               ),
// //             ),
// //             const SizedBox(
// //               width: 7,
// //             ),
// //             Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   bankName,
// //                   style: const TextStyle(
// //                     fontSize: 13,
// //                     fontWeight: FontWeight.w600,
// //                   ),
// //                 ),
// //                 Text(accountNumber.toString(),
// //                     style: TextStyle(
// //                         fontWeight: FontWeight.w500,
// //                         fontSize: 11,
// //                         color: Colors.grey.shade500)),
// //               ],
// //             )
// //           ],
// //         ),
// //         Divider(
// //           height: 30,
// //           thickness: 1,
// //           color: Colors.grey.shade50,
// //         ),
// //         Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             Text("amount",
// //                 style:
// //                     const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
// //             GestureDetector(
// //               child: const Icon(
// //                 Icons.arrow_forward_ios,
// //                 size: 18,
// //                 color: Colors.grey,
// //               ),
// //             )
// //           ],
// //         ),
// //         SizedBox(
// //           height: 12,
// //         ),
// //       ],
// //     ),
// //   );
// // }
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:finance_tracker_app/constants/models/transaction_model.dart';
//
// class BanksModel {
//   String? uid;
//   final String bankId;
//   final String bankName;
//   final double accountNumber;
//   final num amount;
//   TransactionModel? transaction;
//
//   BanksModel({
//     this.uid,
//     required this.bankId,
//     required this.bankName,
//     required this.accountNumber,
//     required this.amount,
//     this.transaction,
//   });
//
//   factory BanksModel.fromDocument(DocumentSnapshot document) {
//     final data = document.data() as Map<String, dynamic>;
//     TransactionModel? transaction;
//     if (data['transactionAmount'] != null) {
//       transaction = TransactionModel.fromMap(data['transactionAmount']);
//     }
//     // Add the transactionAmount to the current amount
//     num updatedAmount = data['amount'] ?? 0;
//     if (transaction != null) {
//       updatedAmount += transaction.amount ??
//           0; // Assuming the `TransactionModel` has an `amount` field
//     }
//
//     return BanksModel(
//       uid: data['uid'],
//       bankId: data['bankId'],
//       bankName: data['bankName'] ?? '',
//       accountNumber: (data['accountNumber'] ?? 0 as num).toDouble(),
//       amount: data['updatedAmount'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'bankId': bankId,
//       'bankName': bankName,
//       'accountNumber': accountNumber,
//       'amount': amount,
//       'uid': uid,
//       "transaction.amount": transaction?.toMap(),
//     };
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class BanksModel {
  String? uid;
  final String bankId;
  final String bankName;
  final double accountNumber;
  final num amount;

  BanksModel({
    this.uid,
    required this.bankId,
    required this.bankName,
    required this.accountNumber,
    required this.amount,
  });

  factory BanksModel.fromDocument(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;

    return BanksModel(
      uid: data['uid'],
      bankId: data['bankId'],
      bankName: data['bankName'] ?? '',
      accountNumber: (data['accountNumber'] ?? 0 as num).toDouble(),
      amount: data['amount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bankId': bankId,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'amount': amount,
      'uid': uid,
    };
  }
}
