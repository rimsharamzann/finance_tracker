import 'package:carousel_slider/carousel_slider.dart';
import 'package:finance_tracker/src/constants/models/budget_model.dart';
import 'package:flutter/material.dart%20';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key, required this.onCategorySelect});

  final Function(int) onCategorySelect;

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  TextEditingController amount = TextEditingController();

  int _selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    // final category = categories[_selectedIndex];
    return CarouselSlider.builder(
      itemCount: categories.length,
      options: CarouselOptions(
        onPageChanged: (index, _) {
          setState(() {
            _selectedCategoryIndex = index;
          });
          widget.onCategorySelect(_selectedCategoryIndex);
        },
        viewportFraction: 0.32,
        enableInfiniteScroll: false,
      ),
      itemBuilder: (BuildContext context, int index, int realIndex) {
        final category = categories[index];

        return Transform.scale(
          scale: _selectedCategoryIndex == index ? 1 : 0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 55,
                backgroundColor: category.color,
                child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.transparent,
                  child: Image.asset(category.image),
                ),
              ),
              const SizedBox(
                height: 13,
              ),
              if (_selectedCategoryIndex == index)
                Text(
                  _selectedCategoryIndex == index
                      ? category.name
                      : category.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                )
            ],
          ),
        );
      },
    );
  }
}

final List<CategoryModel> categories = [
  CategoryModel(
      categoryId: 0,
      name: "Food and Drinks",
      image: "assets/images/img_13.png",
      color: Colors.pink.shade100.withValues(alpha:  0.2)),
  CategoryModel(
      categoryId: 1,
      name: "Entertainment",
      image: "assets/images/img_14.png",
      color: Colors.purple.shade100.withValues(alpha:  0.2)),
  CategoryModel(
      name: "Travel",
      image: "assets/images/img_16.png",
      color: Colors.blue.shade100.withValues(alpha:  0.2),
      categoryId: 2),
  CategoryModel(
      name: "Shopping",
      categoryId: 3,
      image: "assets/images/img_12.png",
      color: Colors.red.shade100.withValues(alpha:  0.2)),
];
