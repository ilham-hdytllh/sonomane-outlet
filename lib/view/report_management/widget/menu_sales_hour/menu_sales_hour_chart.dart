import 'package:d_chart/bar_custom/view.dart';
import 'package:flutter/material.dart';
import 'package:sonomaneoutlet/common/colors.dart';

class MenuSalesHourChart extends StatelessWidget {
  final List transactions;
  const MenuSalesHourChart({Key? key, required this.transactions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<DChartBarDataCustom> createBarDataList() {
      // Buat List untuk menyimpan data menu beserta total gross_amount
      List<Map<String, dynamic>> menuDataList = [];

      // Iterasi melalui transaksi dan perbarui data menu
      for (var entryData in transactions) {
        if (entryData["transaction_status"] == "sukses") {
          final hour =
              entryData['transaction_time'].toString().substring(11, 13);
          num grossAmount = 0;
          num quantity = 0;
          for (var qty in entryData["pesanan"]) {
            grossAmount += qty["price"] * qty["quantity"];
            quantity += qty["quantity"];
          }

          // Cari apakah data menu sudah ada di list
          var existingData = menuDataList.firstWhere(
              (element) => element['hour'] == hour,
              orElse: () => {});

          // Jika data menu sudah ada, update totalAmount dan quantity
          if (existingData.isNotEmpty) {
            existingData['grossAmount'] += grossAmount;
            existingData['quantity'] += quantity;
          } else {
            // Jika data menu belum ada, tambahkan ke list
            menuDataList.add({
              'hour': hour,
              'grossAmount': grossAmount,
              'quantity': quantity,
            });
          }
        }
      }

      // Urutkan list berdasarkan totalAmount dari yang terbesar
      menuDataList.sort((a, b) => b['grossAmount'].compareTo(a['grossAmount']));

      // Buat objek DChartBarDataCustom dari hasil List
      return menuDataList.map((data) {
        final hour = "${data['hour']}:00 (${data["quantity"]})";
        final grossAmount = data['grossAmount'];
        return DChartBarDataCustom(
          valueStyle: Theme.of(context).textTheme.titleMedium,
          color: SonomaneColor.primary,
          value: grossAmount.toDouble(),
          label: hour,
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
