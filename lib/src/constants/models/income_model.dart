// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart%20';
//
// class Transection {
//   String? uid;
//   String transactionName;
//   double amount;
//   DateTime date;
//
//   Transection({
//     this.uid,
//     required this.transactionName,
//     required this.amount,
//     required this.date,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'transactionName': transactionName,
//       'amount': amount,
//       'date': date.toIso8601String(),
//     };
//   }
//
//   factory Transection.fromMap(String id, Map<String, dynamic> map) {
//     return Transection(
//       uid: FirebaseAuth.instance.currentUser?.uid ?? '',
//       transactionName: map['transactionName'] as String,
//       amount: map['amount'] as double,
//       date: DateTime.parse(map['date'] as String),
//     );
//   }
// }
//
// class IncomeList extends StatefulWidget {
//   @override
//   State<IncomeList> createState() => _IncomeListState();
// }
//
// late List<Map<String, dynamic>> items;
//
// class _IncomeListState extends State<IncomeList> {
//   Stream<List<Transection>> fetchIncomes() {
//     return FirebaseFirestore.instance
//         .collection('incomes')
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs.map((doc) {
//         return Transection.fromMap(doc.id, doc.data() as Map<String, dynamic>);
//       }).toList();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 500,
//       child: StreamBuilder<List<Transection>>(
//         stream: fetchIncomes(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           // else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           //   return Center(child: Text('No incomes added yet.'));
//           // }
//           else {
//             final incomes = snapshot.data!;
//
//             return ListView.builder(
//               physics: NeverScrollableScrollPhysics(),
//               shrinkWrap: false,
//               itemCount: incomes.length,
//               itemBuilder: (context, index) {
//                 final income = incomes[index];
//                 return ListTile(
//                   contentPadding: const EdgeInsets.all(0),
//                   leading: CircleAvatar(
//                     backgroundColor: Colors.green[50],
//                     child: const Icon(
//                       Icons.account_balance_wallet,
//                       color: Colors.green,
//                     ),
//                   ),
//                   title: Text(
//                     // ''  "Wallet Balance",
//                     income.transactionName,
//                     style: const TextStyle(
//                         fontSize: 12, fontWeight: FontWeight.w400),
//                   ),
//                   subtitle: Text(
//                     //  "Today",
//                     income.date.toString() ?? "Today",
//                     style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
//                   ),
//                   trailing: Text(
//                     //  "+\$1,820",
//                     income.amount.toString(),
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
