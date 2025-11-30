import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart%20';

class SliverCard extends StatefulWidget {
  const SliverCard({super.key});

  @override
  State<SliverCard> createState() => _SliverCardState();
}

class _SliverCardState extends State<SliverCard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<double> calculatingSpendAnalysisPercentage(String categoryName) async {
    double percentage = 0;
    // getting budget amount
    final budget = await _firestore
        .collection('budget')
        .where('categoryName', isEqualTo: categoryName)
        .get();
    double budgetAmount = 0;

    if (budget.docs.isNotEmpty) {
      for (var doc in budget.docs) {
        final data = doc.data();
        if (data['categoryName'] == categoryName) {
          budgetAmount += data['amount'];
        }
      }
      final expense = await _firestore
          .collection('Transaction')
          .where('categoryName', isEqualTo: categoryName)
          // .where('type', isEqualTo: 'expense')
          .get();
      double expenseAmount = 0;
      for (var doc in expense.docs) {
        final data = doc.data();
        if (data['type'] == 'expense') {
          expenseAmount += data['amount'] ?? 0;
        }
      }

      if (budgetAmount == 0) {
      } else {
        double percentage =
            ((budgetAmount - expenseAmount) / budgetAmount) * 100;
        return percentage;
      }
    }
    return percentage;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 170,
        child: ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: [
            SizedBox(
                height: 170,
                child: Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(
                      right: 0, top: 10, bottom: 10, left: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor:
                            Colors.pinkAccent.shade100.withValues(alpha: 0.2),
                        child: const CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage:
                              AssetImage('assets/images/img_10.png'),
                          radius: 20,
                        ),
                      ),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('Transaction')
                            .where('uid',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser?.uid)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          return FutureBuilder<double>(
                            future: calculatingSpendAnalysisPercentage(
                                'Food and Drinks'),
                            builder: (context, futureSnapshot) {
                              if (!snapshot.hasData) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text("..");
                                }
                                return const Text(
                                  '..',
                                );
                              }

                              double percentage = futureSnapshot.data!;

                              return Text(
                                "${percentage.toStringAsFixed(1)}%",
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          );
                        },
                      ),
                      Text("Food and Drinks",
                          style: TextStyle(
                              fontSize: 10, color: Colors.grey.shade600)),
                    ],
                  ),
                )),
            SizedBox(
                height: 170,
                child: SizedBox(
                  width: 120,
                  height: 160,
                  child: Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(
                        right: 0, top: 10, bottom: 10, left: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor:
                              Colors.blue.shade100.withValues(alpha: 0.2),
                          child: const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                AssetImage('assets/images/img_12.png'),
                            radius: 20,
                          ),
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Transaction')
                              .where('uid',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser?.uid)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            return FutureBuilder<double>(
                              future: calculatingSpendAnalysisPercentage(
                                  'Shopping'),
                              builder: (context, futureSnapshot) {
                                if (!snapshot.hasData) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  return const Text(
                                    '..',
                                  );
                                }

                                double percentage = futureSnapshot.data!;
                                // if (snapshot.connectionState ==
                                //     ConnectionState.waiting) {
                                //   return const Text("..");
                                // }

                                return Text(
                                  "${percentage.toStringAsFixed(1)}%",
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        Text("Shopping",
                            style: TextStyle(
                                fontSize: 10, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                )),
            SizedBox(
                height: 170,
                child: SizedBox(
                  width: 120,
                  height: 160,
                  child: Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(
                        right: 0, top: 10, bottom: 10, left: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor:
                              Colors.greenAccent.shade100.withValues(alpha: 0.2),
                          child: const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                AssetImage('assets/images/img_14.png'),
                            radius: 20,
                          ),
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Transaction')
                              .where('uid',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser?.uid)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            return FutureBuilder<double>(
                              future: calculatingSpendAnalysisPercentage(
                                  'Entertainment'),
                              builder: (context, futureSnapshot) {
                                if (!snapshot.hasData) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Text("..");
                                  }
                                  return const Text(
                                    '..',
                                  );
                                }

                                double percentage = futureSnapshot.data!;

                                return Text(
                                  "${percentage.toStringAsFixed(1)}%",
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        Text("Entertainment",
                            style: TextStyle(
                                fontSize: 10, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                )),
            SizedBox(
                height: 170,
                child: SizedBox(
                  width: 120,
                  height: 160,
                  child: Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(
                        right: 0, top: 10, bottom: 10, left: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.blueAccent.withValues(alpha: 0.2),
                          child: const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                AssetImage('assets/images/img_16.png'),
                            radius: 20,
                          ),
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Transaction')
                              .where('uid',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser?.uid)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            return FutureBuilder<double>(
                              future:
                                  calculatingSpendAnalysisPercentage('Travel'),
                              builder: (context, futureSnapshot) {
                                if (!snapshot.hasData) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  return const Text(
                                    '..',
                                  );
                                }
                                double percentage = futureSnapshot.data!;

                                return Text(
                                  "${percentage.toStringAsFixed(1)}%",
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        Text("Travel",
                            style: TextStyle(
                                fontSize: 10, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                )),
          ],
        ));
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart%20';
//
// class SliverCard extends StatefulWidget {
//   const SliverCard({super.key});
//
//   @override
//   State<SliverCard> createState() => _SliverCardState();
// }
//
// class _SliverCardState extends State<SliverCard> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<double?> calculatingSpendAnalysisPercentage(
//       double pencentage, String categoryName) async {
//     // getting budget amount
//     final budget = await _firestore
//         .collection('budget')
//         .where('categoryName', isEqualTo: categoryName)
//         .get();
//     double budgetAmount = 0;
//     if (budget.docs.isNotEmpty) {
//       budgetAmount = budget.docs.first.get('amount');
//       //getting total expense amount
//       final expense = await _firestore
//           .collection('Transaction')
//           .where('categoryName', isEqualTo: categoryName)
//           .where('type', isEqualTo: 'expense')
//           .get();
//       double expenseAmount = 0;
//       for (var doc in expense.docs) {
//         expenseAmount += doc.get('amount');
//       }
//       if (budgetAmount == 0) {
//         return 0;
//       } else {
//         double percentage =
//             ((budgetAmount - expenseAmount) / budgetAmount) * 100;
//         return percentage;
//       }
//     }
//     return null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 170,
//       child: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('Transaction')
//             .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
//             .snapshots(),
//         builder: (BuildContext context,
//             AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//           return
//               //
//               //
//               //
//               //     _SpendingCategory('Food & drinks', '32%', "assets/images/img_10.png",
//               //         Colors.pinkAccent.shade100.withValues(alpha: 0.2)
//               // ),
//               //
//               //
//               //
//               //
//               //     _SpendingCategory('Entertainment', '17%', "assets/images/img_11.png",
//               //         Colors.purpleAccent.shade100.withValues(alpha: 0.2)),
//               //     _SpendingCategory('Shopping', '16%', "assets/images/img_12.png",
//               //         Colors.blueAccent.shade100.withValues(alpha: 0.2)),
//
//               SizedBox(
//                   width: 130,
//                   height: 160,
//                   child: Card(
//                     color: Colors.white,
//                     margin: const EdgeInsets.only(
//                         right: 0, top: 10, bottom: 10, left: 16),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         CircleAvatar(
//                           radius: 35,
//                           backgroundColor:
//                               Colors.pinkAccent.shade100.withValues(alpha: 0.2),
//                           child: const CircleAvatar(
//                             backgroundColor: Colors.transparent,
//                             backgroundImage:
//                                 AssetImage('assets/images/img_10.png'),
//                             radius: 20,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 10,
//                           child: StreamBuilder<QuerySnapshot>(
//                             stream: FirebaseFirestore.instance
//                                 .collection('Transaction')
//                                 .snapshots(),
//                             builder: (context, snapshot) {
//                               // if (snapshot.connectionState ==
//                               //     ConnectionState.waiting) {
//                               //   return const CircularProgressIndicator();
//                               // }
//
//                               // if (snapshot.hasError ||
//                               //     !snapshot.hasData ||
//                               //     snapshot.data!.docs.isEmpty) {
//                               //   return const Text(
//                               //     r"$0",
//                               //     style: TextStyle(
//                               //         fontSize: 10, color: Colors.white),
//                               //   );
//                               // }
//                               var percentage =
//                                   calculatingSpendAnalysisPercentage(
//                                       snapshot.data!.docs as double,
//                                       'Food and Drinks') as String;
//
//                               return Text(
//                                 "\$${percentage.toString()} %",
//                                 style: const TextStyle(
//                                   fontSize: 10,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         Text("Food and Drinks",
//                             style: TextStyle(
//                                 fontSize: 10, color: Colors.grey.shade600)),
//                       ],
//                     ),
//                   ));
//         },
//       ),
//     );
//   }
// }
//
// Widget _SpendingCategory(
//     String label, String percentage, String img, Color color) {
//   return SizedBox(
//     width: 130,
//     height: 160,
//     child: Card(
//       color: Colors.white,
//       margin: const EdgeInsets.only(right: 0, top: 10, bottom: 10, left: 16),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           CircleAvatar(
//             radius: 35,
//             backgroundColor: color,
//             child: CircleAvatar(
//               backgroundColor: Colors.transparent,
//               backgroundImage: AssetImage(img),
//               radius: 20,
//             ),
//           ),
//           Text(percentage, style: const TextStyle(fontWeight: FontWeight.bold)),
//           Text(label,
//               style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
//         ],
//       ),
//     ),
//   );
// }
