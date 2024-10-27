import 'package:d_chart/bar_custom/view.dart';
import 'package:flutter/material.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';

class MenuSalesCategoryChart extends StatelessWidget {
  final List transactions;
  const MenuSalesCategoryChart({Key? key, required this.transactions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<DChartBarDataCustom> createBarDataList() {
      // Buat List untuk menyimpan data menu beserta total gross_amount
      List<Map<String, dynamic>> menuDataList = [];

      // Iterasi melalui transaksi dan perbarui data menu
      for (var entryData in transactions) {
        if (entryData["transaction_status"] == "sukses") {
          for (var data in entryData['pesanan']) {
            final category = data['category'];
            final quantity = data['quantity'];
            final grossAmount = data['price'].toDouble();
            final discount = data['discount'].toDouble();
            num totalAddon = 0;

            for (var addon in data["addons"]) {
              totalAddon = addon["price"] * addon["quantity"];
            }

            // Hitung total gross_amount setelah dikurangi discount
            final totalAmount =
                ((grossAmount + totalAddon) - (grossAmount * discount)) *
                    quantity;

            // Cari apakah data menu sudah ada di list
            var existingData = menuDataList.firstWhere(
                (element) => element['category'] == category,
                orElse: () => {});

            // Jika data menu sudah ada, update totalAmount dan quantity
            if (existingData.isNotEmpty) {
              existingData['totalAmount'] += totalAmount;
              existingData['quantity'] += quantity;
            } else {
              // Jika data menu belum ada, tambahkan ke list
              menuDataList.add({
                'category': category,
                'totalAmount': totalAmount,
                'quantity': quantity,
              });
            }
          }
        }
      }

      // Urutkan list berdasarkan totalAmount dari yang terbesar
      menuDataList.sort((a, b) => b['totalAmount'].compareTo(a['totalAmount']));

      // // Ambil 5 data pertama dari list yang sudah diurutkan
      // final top5MenuData = menuDataList.take(5).toList();

      // Buat objek DChartBarDataCustom dari hasil List
      return menuDataList.map((data) {
        final category = data['category'];
        final totalAmount = data['totalAmount'];
        final qty = data['quantity'];
        return DChartBarDataCustom(
          color: SonomaneColor.primary,
          valueStyle: Theme.of(context).textTheme.titleMedium,
          value: totalAmount,
          label: "${category.toString().capitalizeSingle()} - $qty pcs",
        );
      }).toList();
    }

    return transactions.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: DChartBarCustom(
              showDomainLabel: true,
              showDomainLine: true,
              showMeasureLabel: true,
              showMeasureLine: true,
              domainLabelStyle: Theme.of(context).textTheme.titleMedium,
              measureLabelStyle: Theme.of(context).textTheme.titleMedium,
              domainLineStyle: BorderSide(
                  width: 2, color: Theme.of(context).colorScheme.tertiary),
              measureLineStyle: BorderSide(
                  width: 2, color: Theme.of(context).colorScheme.tertiary),
              listData: createBarDataList(),
            ),
          )
        : const SizedBox();
  }
}
