import 'package:flutter/material.dart%20';

class CashWallet extends StatelessWidget {
  const CashWallet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 80,
            backgroundColor: Colors.blue.shade50,
            child: Container(
              width: 130,
              height: 130,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                "assets/images/img_8.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 45,
          ),
          const Text(
            "Track Your cash in the wallet",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Get started by adding the amount you  have in your wallet at the moment",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => const AddingWalletBalance(),
                  isScrollControlled: true,
                  scrollControlDisabledMaxHeightRatio: double.infinity,
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(10)),
                  maximumSize:
                      Size(MediaQuery.of(context).size.width * 0.70, 50)),
              child: const Text(
                "Add Wallet Balance",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 80,
          ),
        ],
      ),
    );
  }
}

class AddingWalletBalance extends StatefulWidget {
  const AddingWalletBalance({super.key});

  @override
  State<AddingWalletBalance> createState() => _AddingWalletBalanceState();
}

class _AddingWalletBalanceState extends State<AddingWalletBalance> {
  TextEditingController balance = TextEditingController();
  double _walletBalance = 0;

  void _addWalletBalance() {
    double amount = double.parse(balance.text);
    setState(() {
      _walletBalance = _walletBalance + amount;
      balance.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, 20, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
              width: 50,
              child: Divider(
                height: 5,
                thickness: 2,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            CircleAvatar(
              radius: 70,
              backgroundColor: Colors.blue.shade50,
              child: Container(
                width: 110,
                height: 110,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(
                  "assets/images/img_8.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            const Text(
              "Wallet Balance",
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                  fontSize: 18),
            ),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              height: 45,
              width: MediaQuery.of(context).size.width * 0.6,
              child: TextField(
                controller: balance,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 12),
                    hintText: "Enter current balance",
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
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  _addWalletBalance();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(10)),
                    maximumSize: const Size(double.infinity, 60)),
                child: const Text(
                  "Add Wallet Balance",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
