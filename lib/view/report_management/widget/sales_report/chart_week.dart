import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sonomaneoutlet/common/colors.dart';

class SalesChart extends StatelessWidget {
  final String type;
  final List transactions;
  const SalesChart({Key? key, required this.transactions, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<TimeData> createNumericDataListYear() {
      // Buat Map untuk melacak total gross_amount untuk setiap bulan
      Map<String, double> totalAmountMap = {};

      // Iterasi melalui transaksi dan perbarui total gross_amount
      for (var entryData in transactions) {
        final transactionStatus = entryData['transaction_status'];
        if (transactionStatus == 'sukses') {
          final transactionTime = DateTime.parse(entryData['transaction_time']);
          final monthYearKey =
              "${transactionTime.year}-${transactionTime.month}";

          final grossAmount = entryData['gross_amount'].toDouble();

          // Perbarui total gross_amount untuk bulan tertentu
          totalAmountMap[monthYearKey] =
              (totalAmountMap[monthYearKey] ?? 0) + grossAmount;
        }
      }

      // Ambil tahun saat ini
      int currentYear = DateTime.now().year;

      // Buat list semua bulan dari Januari hingga Desember
      List<String> allMonths =
          List.generate(12, (index) => (index + 1).toString());

      // Buat objek TimeData dari hasil Map, termasuk bulan yang tidak memiliki data
      return allMonths.map((month) {
        final monthYearKey = "$currentYear-$month";
        final totalAmount = totalAmountMap[monthYearKey] ?? 0;
        final parts = monthYearKey.split('-');
        final year = int.parse(parts[0]);
        final parsedMonth = int.parse(parts[1]);

        return TimeData(
          domain: DateTime(year, parsedMonth),
          measure: totalAmount,
          color: SonomaneColor.textTitleDark,
        );
      }).toList();
    }

    List<TimeData> createNumericDataListMonth() {
      // Buat Map untuk melacak total gross_amount untuk setiap tanggal
      Map<String, double> totalAmountMap = {};

      // Iterasi melalui transaksi dan perbarui total gross_amount
      for (var entryData in transactions) {
        final transactionStatus = entryData['transaction_status'];
        if (transactionStatus == 'sukses') {
          final transactionTime = DateTime.parse(entryData['transaction_time']);
          final day = DateFormat("yyyy-MM-dd").format(transactionTime);

          final grossAmount = entryData['gross_amount'].toDouble();

          // Perbarui total gross_amount untuk tanggal tertentu
          totalAmountMap[day] = (totalAmountMap[day] ?? 0) + grossAmount;
        }
      }

      // Buat list semua tanggal dari awal hingga akhir bulan
      // List<String> allDays = type != "This Month"
      //     ? List.generate(
      //         DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day,
      //         (index) => DateFormat("yyyy-MM-dd").format(DateTime(
      //             DateTime.now().year, DateTime.now().month, index + 1)),
      //       )
      //     : List.generate(
      //         DateTime(DateTime.now().year, DateTime.now().month, 0).day,
      //         (index) => DateFormat("yyyy-MM-dd").format(DateTime(
      //             DateTime.now().year, DateTime.now().month - 1, index + 1)),
      //       );

      List<String> createDaysList(int year, int month) {
        int daysInMonth = DateTime(year, month + 1, 0).day;
        return List.generate(
          daysInMonth,
          (index) =>
              DateFormat("yyyy-MM-dd").format(DateTime(year, month, index + 1)),
        );
      }

      List<String> allDays = type == "This Month"
          ? createDaysList(DateTime.now().year, DateTime.now().month)
          : createDaysList(DateTime.now().year, DateTime.now().month - 1);

      // Buat objek NumericData dari hasil Map, termasuk tanggal yang tidak memiliki data
      return allDays.map((day) {
        final totalAmount = totalAmountMap[day] ?? 0;
        return TimeData(
          domain: DateTime.parse(day),
          measure: totalAmount,
          color: SonomaneColor.textTitleDark,
        );
      }).toList();
    }

    List<TimeData> createNumericDataList() {
      // Buat Map untuk melacak total gross_amount untuk setiap tanggal
      Map<String, double> totalAmountMap = {};

      // Iterasi melalui transaksi dan perbarui total gross_amount
      for (var entryData in transactions) {
        final transactionStatus = entryData['transaction_status'];
        if (transactionStatus == 'sukses') {
          final day = DateFormat("yyyy-MM-dd").format(
            DateTime.parse(entryData['transaction_time']),
          );

          final grossAmount = entryData['gross_amount'].toDouble();

          // Perbarui total gross_amount untuk tanggal tertentu
          totalAmountMap[day] = (totalAmountMap[day] ?? 0) + grossAmount;
        }
      }

      // Ambil tanggal hari ini dan bulan saat ini
      DateTime currentDate = DateTime.now();
      int currentDayOfWeek = currentDate.weekday;

      // Buat list semua tanggal dari Senin hingga Minggu
      List<String> allDays = List.generate(
        7,
        (index) {
          // Hitung selisih hari dari hari ini dan bulan saat ini
          int difference = index - currentDayOfWeek + 1;

          // Hitung tanggal berdasarkan selisih
          DateTime day = currentDate.add(Duration(days: difference));

          return DateFormat("yyyy-MM-dd").format(day);
        },
      );

      // Buat objek TimeData dari hasil Map, termasuk tanggal yang tidak memiliki data
      return allDays.map((day) {
        final totalAmount = totalAmountMap[day] ?? 0;
        return TimeData(
          domain: DateTime.parse(day),
          measure: totalAmount,
          color: SonomaneColor.textTitleDark,
        );
      }).toList();
    }

    return transactions.isNotEmpty && type != "Today"
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: DChartLineT(
              configRenderLine: ConfigRenderLine(
                  includePoints: true, includeArea: true, strokeWidthPx: 2),
              areaColor: (group, ordinalData, index) {
                return SonomaneColor.primary.withOpacity(0.1);
              },
              groupList: [
                TimeGroup(
                  color: SonomaneColor.primary,
                  chartType: ChartType.line,
                  id: '1',
                  data: type == "This Year"
                      ? createNumericDataListYear()
                      : type == "This Month" || type == "Last Month"
                          ? createNumericDataListMonth()
                          : createNumericDataList(),
                ),
              ],
              animate: true,
              animationDuration: const Duration(milliseconds: 800),
              domainAxis: DomainAxis(
                showLine: true,
                lineStyle: LineStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    thickness: 2),
                labelStyle: LabelStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.tertiary),
              ),
              measureAxis: MeasureAxis(
                showLine: true,
                lineStyle: LineStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    thickness: 2),
                labelStyle: LabelStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.tertiary),
              ),
            ),
          )
        : const SizedBox();
  }
}
