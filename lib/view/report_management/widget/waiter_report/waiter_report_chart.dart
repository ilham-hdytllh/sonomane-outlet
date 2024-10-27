import 'package:d_chart/bar_custom/view.dart';
import 'package:flutter/material.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';

class WaiterChart extends StatefulWidget {
  final List<Map<String, dynamic>> transactions;

  const WaiterChart({super.key, required this.transactions});

  @override
  // ignore: library_private_types_in_public_api
  _WaiterChartState createState() => _WaiterChartState();
}

class _WaiterChartState extends State<WaiterChart> {
  @override
  Widget build(BuildContext context) {
    List<DChartBarDataCustom> createBarDataList() {
      // Buat List untuk menyimpan data menu beserta total gross_amount
      List<Map<String, dynamic>> menuDataList = [];

      // Iterasi melalui transaksi dan perbarui data menu
      for (var entryData in widget.transactions) {
        if (entryData["transaction_status"] == "sukses") {
          final waiterName = entryData['waiter'];
          num grossAmount = entryData['gross_amount'];

          // Cari apakah data menu sudah ada di list
          var existingData = menuDataList.firstWhere(
              (element) => element['waiterName'] == waiterName,
              orElse: () => {});

          // Jika data menu sudah ada, update totalAmount dan quantity
          if (existingData.isNotEmpty) {
            existingData['grossAmount'] += grossAmount;
          } else {
            // Jika data menu belum ada, tambahkan ke list
            menuDataList.add({
              'waiterName': waiterName,
              'grossAmount': grossAmount,
            });
          }
        }
      }

      // Urutkan list berdasarkan totalAmount dari yang terbesar
      menuDataList.sort((a, b) => b['grossAmount'].compareTo(a['grossAmount']));

      // Buat objek DChartBarDataCustom dari hasil List
      return menuDataList.map((data) {
        final waiterName = data['waiterName'];
        num totalAmount = data['grossAmount'];
        return DChartBarDataCustom(
          color: SonomaneColor.primary,
          valueStyle: Theme.of(context).textTheme.titleMedium,
          value: totalAmount.toDouble(),
          label: waiterName.toString().capitalize(),
        );
      }).toList();
    }

    return widget.transactions.isNotEmpty
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
