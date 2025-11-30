import 'package:flutter/material.dart';
class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  int selectedMonthIndex = 0;

  final List<String> months = ["Jan 2022", "Dec 2021", "Nov 2021", "Oct 2021"];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(months.length, (index) {
          bool isSelected = index == selectedMonthIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedMonthIndex = index;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              margin: isSelected
                  ? const EdgeInsets.symmetric(vertical: 6, horizontal: 10)
                  : const EdgeInsets.all(0),
              width: 110,
              height: 40,
              decoration: isSelected
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color:
                          isSelected ? Colors.grey.shade50 : Colors.transparent,
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            blurRadius: 1,
                            spreadRadius: 1.5,
                            color: Colors.grey.shade100,
                          ),
                      ],
                      border: Border.all(
                        color: isSelected
                            ? Colors.grey.shade400
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    )
                  : const BoxDecoration(),
              child: Text(
                months[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.black87 : Colors.grey.shade400,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
