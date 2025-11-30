// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class DbServices {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<double?> calculatingSpendAnalysisPercentage(
//       String categoryName) async {
//     double percentage = 0;
//     // getting budget amount
//     final budget = await _firestore
//         .collection('budget')
//         .where('categoryName', isEqualTo: categoryName)
//         .get();
//     double budgetAmount = 0;
//     if (budget.docs.isNotEmpty) {
//       for (var doc in budget.docs) {
//         final data = doc.data();
//         if (data['categoryName'] == categoryName) {
//           budgetAmount += data['amount'];
//         }
//       }
//       final expense = await _firestore
//           .collection('Transaction')
//           .where('categoryName', isEqualTo: categoryName)
//           // .where('type', isEqualTo: 'expense')
//           .get();
//       double expenseAmount = 0;
//       for (var doc in expense.docs) {
//         final data = doc.data();
//         if (data['type'] == 'expense') {
//           expenseAmount += data['amount'] ?? 0;
//         }
//       }
//
//
//
//
//
//       if (budgetAmount == 0) {
//         return 0;
//       } else {
//         double percentage =
//             ((budgetAmount - expenseAmount) / budgetAmount) * 100;
//         return percentage;
//       }
//     }
//     return percentage;
//   }
// }
//
//
//
//
//
//
//
//
// Future<double?> updateAmount(List<QueryDocumentSnapshot> transactions, BanksModel? bank) async {
//   double bankAmount = 0;
//
//   // Calculate the total bank amount from the transactions
//   for (var doc in transactions) {
//     final data = doc.data() as Map<String, dynamic>;
//     if (data['bankId'] == bank?.bankId) {
//       bankAmount += data['amount'] ?? 0;
//     }
//   }
//
//   // If no bank is provided, or no amount has been calculated, return the current bank amount
//   if (bank == null) {
//     return bankAmount;
//   }
//
//   // try {
//   //   // Get the list of all banks that match the given bankId
//   //   var banks = await FirebaseFirestore.instance
//   //       .collection('banks')
//   //       .where('bankId', isEqualTo: bank.bankId)
//   //       .get();
//   //
//   //   // Check if any banks were found
//   //   if (banks.docs.isNotEmpty) {
//   //     // Iterate through all matching bank documents and update them
//   //     for (var bankDoc in banks.docs) {
//   //       await bankDoc.reference.update({
//   //         'amount': bankAmount,
//   //       });
//   //     }
//   //   }
//   // } catch (e) {
//   //   // Log or handle the error as needed
//   //   print('Error updating bank amount: $e');
//   // }
//   //
//   // // Return the total bank amount
//   return bankAmount;
// }
