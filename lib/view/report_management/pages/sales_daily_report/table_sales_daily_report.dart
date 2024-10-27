import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/behavior.dart';

class TableSalesDailyReport extends StatefulWidget {
  final List<Map<String, dynamic>> transaction;
  const TableSalesDailyReport({super.key, required this.transaction});

  @override
  State<TableSalesDailyReport> createState() => _TableSalesDailyReportState();
}

class _TableSalesDailyReportState extends State<TableSalesDailyReport> {
  List<Map<String, dynamic>> combineTransactions(
      List<Map<String, dynamic>> transactions) {
    Map<String, List<dynamic>> groupedTransactions = {};

    for (Map<String, dynamic> transaction in transactions) {
      if (transaction["transaction_status"] == "sukses") {
        DateTime transactionDate =
            DateTime.parse(transaction['transaction_time']);
        String formattedDate =
            "${transactionDate.year}-${transactionDate.month}-${transactionDate.day}";

        if (!groupedTransactions.containsKey(formattedDate)) {
          groupedTransactions[formattedDate] = [];
        }

        // Assuming 'pesanan' is a List<dynamic>
        groupedTransactions[formattedDate]
            ?.addAll(transaction['pesanan'] as List<dynamic>);
      }
    }

    List<Map<String, dynamic>> result = [];

    groupedTransactions.forEach((date, orders) {
      int totalGuests = transactions
          .where((transaction) =>
              "${DateTime.parse(transaction['transaction_time']).year}-${DateTime.parse(transaction['transaction_time']).month}-${DateTime.parse(transaction['transaction_time']).day}" ==
              date)
          .fold(0, (sum, transaction) => sum + (transaction['guest'] as int));

      Map<String, dynamic> combinedTransaction = {
        'combinedDate': date,
        'combinedPesanan': orders,
        'totalGuests': totalGuests,
      };

      result.add(combinedTransaction);
    });
    debugPrint(result.toString(), wrapWidth: 100000);
    return result;
  }

  @override
  void initState() {
    super.initState();
    combineTransactions(widget.transaction);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: SizedBox(
        width: double.infinity,
        child: ScrollConfiguration(
          behavior: NoGloww(),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              showBottomBorder: true,
              headingRowColor: MaterialStateColor.resolveWith(
                (states) => Theme.of(context).colorScheme.background,
              ),
              headingRowHeight: 65.h,
              dataRowMaxHeight: 50.h,
              dataRowMinHeight: 50.h,
              headingTextStyle: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14),
              columns: [
                const DataColumn(label: Text('Date')),
                const DataColumn(label: Text('Description')),
                DataColumn(
                    label: SizedBox(
                  width: 166.w,
                  height: 65.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Breakfast (08.00 - 10.59)'),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Center(child: Text('Real')),
                              ),
                              Expanded(
                                child: Center(child: Text('Avg')),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
                DataColumn(
                    label: SizedBox(
                  width: 166.w,
                  height: 65.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Lunch (11.00 - 14.59)'),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Center(child: Text('Real')),
                              ),
                              Expanded(
                                child: Center(child: Text('Avg')),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
                DataColumn(
                    label: SizedBox(
                  width: 166.w,
                  height: 65.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Coff.Break (15.00 - 17.59)'),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Center(child: Text('Real')),
                              ),
                              Expanded(
                                child: Center(child: Text('Avg')),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
                DataColumn(
                    label: SizedBox(
                  width: 166.w,
                  height: 65.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Dinner (18.00 - 23.59)	'),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Center(child: Text('Real')),
                              ),
                              Expanded(
                                child: Center(child: Text('Avg')),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
                DataColumn(
                    label: SizedBox(
                  width: 166.w,
                  height: 65.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Else (00.00 - 07.59)'),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Center(child: Text('Real')),
                              ),
                              Expanded(
                                child: Center(child: Text('Avg')),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
                DataColumn(
                    label: SizedBox(
                  width: 166.w,
                  height: 65.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Total'),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Center(child: Text('Real')),
                              ),
                              Expanded(
                                child: Center(child: Text('Avg')),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
              ],
              rows: [],
            ),
          ),
        ),
      ),
    );
  }
}
