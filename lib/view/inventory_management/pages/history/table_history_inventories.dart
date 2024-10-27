// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:sonomaneoutlet/common/colors.dart';
// import 'package:sonomaneoutlet/common/extension_capitalized.dart';

// // ignore: must_be_immutable
// class HistoryInventories extends StatefulWidget {
//   List data;
//   HistoryInventories({super.key, required this.data});

//   @override
//   State<HistoryInventories> createState() => _HistoryInventoriesState();
// }

// class _HistoryInventoriesState extends State<HistoryInventories> {
//   int _rowsPerPage = 9;
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: double.infinity,
//       child: Column(
//         mainAxisSize: MainAxisSize.max,
//         children: [
//           Expanded(
//             child: SizedBox(
//               width: double.infinity,
//               height: double.infinity,
//               child: PaginatedDataTable(
//                 rowsPerPage: _rowsPerPage,
//                 availableRowsPerPage: const [9],
//                 onRowsPerPageChanged: (int? value) {
//                   setState(() {
//                     _rowsPerPage = value!;
//                   });
//                 },
//                 headingRowColor: MaterialStateColor.resolveWith(
//                     (states) => Theme.of(context).colorScheme.background),
//                 headingRowHeight: 50.h,
//                 dataRowMaxHeight: 48.h,
//                 dataRowMinHeight: 48.h,
//                 columns: [
//                   DataColumn(
//                     label: Text(
//                       'No',
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleMedium!
//                           .copyWith(fontSize: 14.sp),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Text(
//                       'Batch',
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleMedium!
//                           .copyWith(fontSize: 14.sp),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Text(
//                       'Name',
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleMedium!
//                           .copyWith(fontSize: 14.sp),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Text(
//                       'Quantity',
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleMedium!
//                           .copyWith(fontSize: 14.sp),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Text(
//                       'Date',
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleMedium!
//                           .copyWith(fontSize: 14.sp),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Text(
//                       'Type',
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleMedium!
//                           .copyWith(fontSize: 14.sp),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Text(
//                       'By',
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleMedium!
//                           .copyWith(fontSize: 14.sp),
//                     ),
//                   ),
//                 ],
//                 source: Paginated(data: widget.data, context: context),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Paginated extends DataTableSource {
//   BuildContext context;
//   List data;
//   Paginated({required this.data, required this.context});

//   @override
//   DataRow getRow(int index) {
//     return DataRow.byIndex(
//       index: index,
//       cells: [
//         DataCell(
//           SizedBox(
//             child: Text(
//               (index + 1).toString(),
//               style: Theme.of(context)
//                   .textTheme
//                   .titleMedium!
//                   .copyWith(fontSize: 14.sp),
//             ),
//           ),
//         ),
//         DataCell(Text(
//           data[index]['batch'],
//           style: Theme.of(context)
//               .textTheme
//               .titleMedium!
//               .copyWith(fontSize: 14.sp),
//         )),
//         DataCell(Text(
//           data[index]['name'],
//           style: Theme.of(context)
//               .textTheme
//               .titleMedium!
//               .copyWith(fontSize: 14.sp),
//         )),
//         DataCell(Text(
//           data[index]['quantity'].toString(),
//           style: Theme.of(context)
//               .textTheme
//               .titleMedium!
//               .copyWith(fontSize: 14.sp),
//         )),
//         DataCell(Text(
//           data[index]['datetime'],
//           style: Theme.of(context)
//               .textTheme
//               .titleMedium!
//               .copyWith(fontSize: 14.sp),
//         )),
//         DataCell(Container(
//           width: 80.w,
//           height: 30.h,
//           padding: EdgeInsets.symmetric(vertical: 4.h),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(5.r),
//               color: data[index]['type'] == "return"
//                   ? SonomaneColor.blue
//                   : SonomaneColor.orange),
//           child: Center(
//             child: Text(
//               data[index]['type'].toString().capitalizeSingle(),
//               style: Theme.of(context)
//                   .textTheme
//                   .titleMedium!
//                   .copyWith(color: SonomaneColor.containerLight),
//             ),
//           ),
//         )),
//         DataCell(Text(
//           data[index]['user'],
//           style: Theme.of(context)
//               .textTheme
//               .titleMedium!
//               .copyWith(fontSize: 14.sp),
//         )),
//       ],
//     );
//   }

//   @override
//   bool get isRowCountApproximate => false;

//   @override
//   int get rowCount => data.length;

//   @override
//   int get selectedRowCount => 0;
// }
