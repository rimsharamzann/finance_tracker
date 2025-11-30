import 'package:flutter/material.dart%20';

class HomePageTransaction extends StatefulWidget {
  const HomePageTransaction({super.key});

  @override
  State<HomePageTransaction> createState() => _HomePageTransactionState();
}

class _HomePageTransactionState extends State<HomePageTransaction> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        itemCount: 5,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return const ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 0),
            leading: CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage("assets/images/img_3.png"
                  // trans.img,
                  ),
            ),
            title: Text(
              "",
              // trans.name,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 12.5),
            ),
            subtitle: Text(
              "",
              // trans.time,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                  fontSize: 12),
            ),
            trailing: Text(
              "",
              // trans.money,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
          );
        });
  }
}
