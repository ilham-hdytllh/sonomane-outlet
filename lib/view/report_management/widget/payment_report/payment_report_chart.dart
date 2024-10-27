import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sonomaneoutlet/common/colors.dart';

class PaymentChart extends StatelessWidget {
  final String type;
  final List transactions;

  const PaymentChart({Key? key, required this.transactions, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return transactions.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: DChartLineT(
              configRenderLine: ConfigRenderLine(
                  includePoints: true, includeArea: true, strokeWidthPx: 2),
              areaColor: (group, ordinalData, index) {
                if (group.id == "tunai") {
                  return Colors.orange.withOpacity(0.2);
                } else if (group.id == "debit_bca") {
                  return SonomaneColor.blue.withOpacity(0.2);
                } else if (group.id == "debit_mandiri") {
                  return Colors.green.withOpacity(0.2);
                } else if (group.id == "cc_bca") {
                  return SonomaneColor.primary.withOpacity(0.2);
                } else if (group.id == "cc_mandiri") {
                  return Colors.pink.withOpacity(0.2);
                } else if (group.id == "go_food") {
                  return Colors.purple.withOpacity(0.2);
                } else if (group.id == "grab_food") {
                  return Colors.redAccent.withOpacity(0.2);
                } else if (group.id == "qris_bca") {
                  return Colors.yellowAccent.withOpacity(0.2);
                } else {
                  return Colors.deepPurpleAccent.withOpacity(0.2);
                }
              },
              groupList: createGroups(context),
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

  List<TimeGroup> createGroups(BuildContext context) {
    return [
      TimeGroup(
        color: Colors.orange,
        chartType: ChartType.line,
        id: 'tunai',
        data: type == "This Year"
            ? createNumericDataListYear("tunai")
            : type == "This Month"
                ? createNumericDataListMonth("tunai")
                : createNumericDataListWeek("tunai"),
      ),
      TimeGroup(
        color: SonomaneColor.blue,
        chartType: ChartType.line,
        id: 'debit_bca',
        data: type == "This Year"
            ? createNumericDataListYear("debit_bca")
            : type == "This Month"
                ? createNumericDataListMonth("debit_bca")
                : createNumericDataListWeek("debit_bca"),
      ),
      TimeGroup(
        color: Colors.green,
        chartType: ChartType.line,
        id: 'debit_mandiri',
        data: type == "This Year"
            ? createNumericDataListYear("debit_mandiri")
            : type == "This Month"
                ? createNumericDataListMonth("debit_mandiri")
                : createNumericDataListWeek("debit_mandiri"),
      ),
      TimeGroup(
        color: SonomaneColor.primary,
        chartType: ChartType.line,
        id: 'cc_bca',
        data: type == "This Year"
            ? createNumericDataListYear("cc_bca")
            : type == "This Month"
                ? createNumericDataListMonth("cc_bca")
                : createNumericDataListWeek("cc_bca"),
      ),
      TimeGroup(
        color: Colors.pink,
        chartType: ChartType.line,
        id: 'cc_mandiri',
        data: type == "This Year"
            ? createNumericDataListYear("cc_mandiri")
            : type == "This Month"
                ? createNumericDataListMonth("cc_mandiri")
                : createNumericDataListWeek("cc_mandiri"),
      ),
      TimeGroup(
        color: Colors.purple,
        chartType: ChartType.line,
        id: 'go_food',
        data: type == "This Year"
            ? createNumericDataListYear("go_food")
            : type == "This Month"
                ? createNumericDataListMonth("go_food")
                : createNumericDataListWeek("go_food"),
      ),
      TimeGroup(
        color: Colors.redAccent,
        chartType: ChartType.line,
        id: 'grab_food',
        data: type == "This Year"
            ? createNumericDataListYear("grab_food")
            : type == "This Month"
                ? createNumericDataListMonth("grab_food")
                : createNumericDataListWeek("grab_food"),
      ),
      TimeGroup(
        color: Colors.yellowAccent,
        chartType: ChartType.line,
        id: 'qris_bca',
        data: type == "This Year"
            ? createNumericDataListYear("qris_bca")
            : type == "This Month"
                ? createNumericDataListMonth("qris_bca")
                : createNumericDataListWeek("qris_bca"),
      ),
      TimeGroup(
        color: Colors.deepPurpleAccent,
        chartType: ChartType.line,
        id: 'qris_mandiri',
        data: type == "This Year"
            ? createNumericDataListYear("qris_mandiri")
            : type == "This Month"
                ? createNumericDataListMonth("qris_mandiri")
                : createNumericDataListWeek("qris_mandiri"),
      ),
      TimeGroup(
        color: Theme.of(context).colorScheme.tertiary,
        chartType: ChartType.line,
        id: 'payment gateway',
        data: type == "This Year"
            ? createNumericDataListYear("payment gateway")
            : type == "This Month"
                ? createNumericDataListMonth("payment gateway")
                : createNumericDataListWeek("payment gateway"),
      ),
    ];
  }

  List<TimeData> createNumericDataListYear(String paymentType) {
    // Buat Map untuk melacak total gross_amount untuk setiap bulan
    Map<String, double> totalAmountMap = {};

    // Iterasi melalui transaksi dan perbarui total gross_amount
    for (var entryData in transactions) {
      final transactionStatus = entryData['transaction_status'];
      if (transactionStatus == 'sukses' &&
          entryData["payment_type"] == paymentType) {
        final transactionTime = DateTime.parse(entryData['transaction_time']);
        final monthYearKey = "${transactionTime.year}-${transactionTime.month}";

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

  List<TimeData> createNumericDataListMonth(String paymentType) {
    // Buat Map untuk melacak total gross_amount untuk setiap tanggal
    Map<String, double> totalAmountMap = {};

    // Iterasi melalui transaksi dan perbarui total gross_amount
    for (var entryData in transactions) {
      final transactionStatus = entryData['transaction_status'];
      if (transactionStatus == 'sukses' &&
          entryData["payment_type"] == paymentType) {
        final transactionTime = DateTime.parse(entryData['transaction_time']);
        final day = DateFormat("yyyy-MM-dd").format(transactionTime);

        final grossAmount = entryData['gross_amount'].toDouble();

        // Perbarui total gross_amount untuk tanggal tertentu
        totalAmountMap[day] = (totalAmountMap[day] ?? 0) + grossAmount;
      }
    }

    // Buat list semua tanggal dari awal hingga akhir bulan
    // List<String> allDays = List.generate(
    //   DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day,
    //   (index) => DateFormat("yyyy-MM-dd").format(
    //       DateTime(DateTime.now().year, DateTime.now().month, index + 1)),
    // );

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

  List<TimeData> createNumericDataListWeek(String paymentType) {
    // Buat Map untuk melacak total gross_amount untuk setiap tanggal
    Map<String, double> totalAmountMap = {};

    // Iterasi melalui transaksi dan perbarui total gross_amount
    for (var entryData in transactions) {
      final transactionStatus = entryData['transaction_status'];
      if (transactionStatus == 'sukses' &&
          entryData["payment_type"] == paymentType) {
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
}
