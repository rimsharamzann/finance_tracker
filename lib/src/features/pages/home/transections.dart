import 'package:flutter/material.dart';

class Transac extends StatefulWidget {
  const Transac({super.key});

  @override
  State<Transac> createState() => _TransacState();
}

class _TransacState extends State<Transac> {
  final List<TransModel> transec = [
    TransModel(
      img: "assets/images/img_2.png",
      name: "Zomato",
      time: "today . 9:PM",
      money: "\$0",
    ),
    TransModel(
      img: "assets/images/img_3.png",
      name: "inDrive",
      time: "today 6:pm",
      money: "\$0",
    ),
    TransModel(
      img: "assets/images/img_3.png",
      name: "inDrive",
      time: "today 6:pm",
      money: "\$0",
    ),
    TransModel(
      img: "assets/images/img_1.png",
      name: "inDrive",
      time: "today 6:pm",
      money: "\$0",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        itemCount: transec.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final trans = transec[index];
          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
            leading: CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage(
                trans.img,
              ),
            ),
            title: Text(
              trans.name,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 12.5),
            ),
            subtitle: Text(
              trans.time,
              style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                  fontSize: 12),
            ),
            trailing: Text(
              trans.money,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
          );
        });
  }
}

class TransModel {
  final String img;
  final String name;
  final String time;
  final String money;

  TransModel({
    required this.img,
    required this.name,
    required this.time,
    required this.money,
  });
}
