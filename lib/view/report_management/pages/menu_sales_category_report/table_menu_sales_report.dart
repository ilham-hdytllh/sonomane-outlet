import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/curencyformat.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';

class TableMenuCategorySalesReport extends StatefulWidget {
  final List data;

  const TableMenuCategorySalesReport({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TableMenuCategorySalesReportState createState() =>
      _TableMenuCategorySalesReportState();
}

class _TableMenuCategorySalesReportState
    extends State<TableMenuCategorySalesReport> {
  final List _category = [];
  late Map<String, List<dynamic>> _categoryMenuMap;

  @override
  void initState() {
    super.initState();
    _categoryMenuMap = {};
    FirebaseFirestore.instance
        .collection("category")
        .orderBy("name", descending: false)
        .get()
        .then((value) {
      for (var data in value.docs) {
        _category.add(data["name"]);
        _categoryMenuMap[data["name"]] = [];
      }

      // Organize transaction data by category
      for (var transaction in widget.data) {
        if (transaction["transaction_status"] == "sukses") {
          List<dynamic> menuList = transaction["pesanan"];
          for (String category in _category) {
            _categoryMenuMap[category]!
                .addAll(menuList.where((menu) => menu["category"] == category));
          }
        }
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _category.map((category) {
        return CategoryTable(
          categoryName: category,
          menuList: _categoryMenuMap[category] ?? [],
        );
      }).toList(),
    );
  }
}

class CategoryTable extends StatelessWidget {
  final String categoryName;
  final List<dynamic> menuList;

  const CategoryTable({
    Key? key,
    required this.categoryName,
    required this.menuList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Group menu items by name
    Map<String, List<dynamic>> groupedMenu = {};
    for (var menu in menuList) {
      String menuName = menu["name"].toString();
      if (!groupedMenu.containsKey(menuName)) {
        groupedMenu[menuName] = [];
      }
      groupedMenu[menuName]!.add(menu);
    }

    // Calculate aggregated values
    num totalQuantity = 0;
    double totalPrice = 0;
    double totalDiscount = 0;
    num totalAdditional = 0;

    for (var entry in groupedMenu.entries) {
      List<dynamic> menuGroup = entry.value;
      for (var menu in menuGroup) {
        totalQuantity += menu["quantity"];
        totalPrice += menu["price"];
        totalDiscount += menu["price"] * menu["discount"];
        for (var addon in menu["addons"]) {
          totalAdditional = addon["price"] * addon["quantity"];
        }
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Category: ${categoryName.toString().capitalize()}",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 18.sp),
          ),
          SizedBox(
            height: 15.h,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              showBottomBorder: true,
              headingRowColor: MaterialStateColor.resolveWith(
                (states) => Theme.of(context).colorScheme.background,
              ),
              headingRowHeight: 50.h,
              dataRowMaxHeight: 50.h,
              dataRowMinHeight: 50.h,
              dataTextStyle: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
              headingTextStyle: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14),
              columns: const [
                DataColumn(
                  label: Text(
                    "Menu",
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Cat',
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Sub Cat',
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Qty',
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Sub Total',
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Additional Price',
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Diskon',
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Grand Total',
                  ),
                ),
              ],
              rows: [
                // Data Rows
                ...groupedMenu.entries.map((entry) {
                  String menuName = entry.key;
                  List<dynamic> menuGroup = entry.value;

                  // Calculate total quantity, price, and other values
                  num totalQuantity = 0;
                  double totalPrice = 0;
                  double totalDiscount = 0;
                  num totalAdditional = 0;

                  for (var menu in menuGroup) {
                    totalQuantity += menu["quantity"];
                    totalPrice += menu["price"];
                    totalDiscount += (menu["price"] * menu["discount"]);
                    for (var addon in menu["addons"]) {
                      totalAdditional = addon["price"] * addon["quantity"];
                    }
                  }

                  return DataRow(
                    cells: [
                      DataCell(Text(menuName.capitalizeSingle())),
                      DataCell(Text(
                          menuGroup[0]["category"].toString().capitalize())),
                      DataCell(Text(
                          menuGroup[0]["subcategory"].toString().capitalize())),
                      DataCell(Text(totalQuantity.toString())),
                      DataCell(Text(
                        CurrencyFormat.convertToIdr(totalPrice, 0),
                      )),
                      DataCell(Text(
                        CurrencyFormat.convertToIdr(totalAdditional, 0),
                      )),
                      DataCell(Text(
                        CurrencyFormat.convertToIdr(totalDiscount, 0),
                      )),
                      DataCell(Text(
                        CurrencyFormat.convertToIdr(
                            (totalPrice + totalAdditional) - totalDiscount, 0),
                      )),
                    ],
                  );
                }).toList(),

                DataRow(cells: [
                  DataCell(Container()),
                  DataCell(Container()),
                  DataCell(
                    Text(
                      'TOTAL',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataCell(
                    Text(
                      totalQuantity.toString(),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataCell(
                    Text(
                      CurrencyFormat.convertToIdr(totalPrice, 0),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataCell(
                    Text(
                      CurrencyFormat.convertToIdr(totalAdditional, 0),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataCell(
                    Text(
                      CurrencyFormat.convertToIdr(totalDiscount, 0),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataCell(
                    Text(
                      CurrencyFormat.convertToIdr(
                          (totalPrice + totalAdditional) - totalDiscount, 0),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
