// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:sonomaneoutlet/common/colors.dart';
// import 'package:sonomaneoutlet/view/inventory_management/widget/inventory_card.dart';
// import 'package:sonomaneoutlet/view/inventory_management/widget/move_dialog.dart';

// class InvetoryManagement extends StatefulWidget {
//   const InvetoryManagement({super.key});

//   @override
//   State<InvetoryManagement> createState() => _InvetoryManagementState();
// }

// class _InvetoryManagementState extends State<InvetoryManagement> {
//   final _listViewKey = GlobalKey();
//   final ScrollController _scroller = ScrollController();
//   bool _isDragging = false;

//   @override
//   void dispose() {
//     _scroller.dispose();
//     super.dispose();
//   }

//   Stream? placeInventory;
//   Stream? stocks;

//   @override
//   void initState() {
//     super.initState();
//     placeInventory = FirebaseFirestore.instance
//         .collection("placeInventory")
//         .orderBy("name", descending: false)
//         .snapshots();
//     stocks = FirebaseFirestore.instance
//         .collection("stocks")
//         .where("placement", isEqualTo: false)
//         .snapshots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(top: 30.h, bottom: 30.h),
//       child: SizedBox(
//         height: double.infinity,
//         width: double.infinity,
//         child: Listener(
//           child: Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 15.0.w),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Control Storage",
//                       style: Theme.of(context).textTheme.headlineLarge,
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 6.0.w, vertical: 2.h),
//                 child: StreamBuilder(
//                     stream: stocks,
//                     builder: (context, snapshot) {
//                       if (snapshot.hasError) {
//                         return Center(
//                           child: Text(
//                             "Error database",
//                             style: Theme.of(context).textTheme.titleMedium,
//                           ),
//                         );
//                       } else if (snapshot.connectionState ==
//                           ConnectionState.waiting) {
//                         return Row(
//                           children: [
//                             for (int a = 0; a < 4; a++) ...{
//                               SizedBox(
//                                 width: 240.w,
//                                 height: 50.h,
//                                 child: Shimmer.fromColors(
//                                   baseColor: Colors.grey.shade100,
//                                   highlightColor: Colors.grey.shade200,
//                                   child: const Card(),
//                                 ),
//                               ),
//                             },
//                           ],
//                         );
//                       } else if (snapshot.data.docs.isNotEmpty) {
//                         List data = [];
//                         snapshot.data.docs.map((e) {
//                           Map a = e.data();
//                           a["idDoc"] = e.id;
//                           data.add(a);
//                         }).toList();
//                         return SizedBox(
//                           width: double.infinity,
//                           height: 115.h,
//                           child: Column(
//                             children: [
//                               Container(
//                                 margin: EdgeInsets.only(left: 8.w),
//                                 height: 50.h,
//                                 width: double.infinity,
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(5.r),
//                                     color:
//                                         SonomaneColor.orange.withOpacity(0.2)),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     SizedBox(
//                                       width: 10.w,
//                                     ),
//                                     Icon(
//                                       Icons.warning_rounded,
//                                       size: 26.sp,
//                                       color: SonomaneColor.orange,
//                                     ),
//                                     SizedBox(
//                                       width: 10.w,
//                                     ),
//                                     Text(
//                                       "Ada item yang belum di tempatkan ?",
//                                       style: TextStyle(
//                                           color: SonomaneColor.orange,
//                                           fontSize: 14.sp,
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 10.h,
//                               ),
//                               Expanded(
//                                 child: ListView.builder(
//                                   padding: EdgeInsets.only(left: 10.w),
//                                   scrollDirection: Axis.horizontal,
//                                   itemCount: data.length,
//                                   itemBuilder: (context, index) {
//                                     return Padding(
//                                       padding: EdgeInsets.only(right: 10.0.w),
//                                       child: Draggable(
//                                         feedback: Container(
//                                           height: 60.h,
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(5.r),
//                                             border: Border.all(
//                                                 width: 0.1.w,
//                                                 color: Colors.grey.shade500),
//                                           ),
//                                           width: 240.w,
//                                           child: Row(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.center,
//                                             children: [
//                                               Container(
//                                                 width: 5.w,
//                                                 height: double.infinity,
//                                                 decoration: BoxDecoration(
//                                                   color: SonomaneColor.orange,
//                                                   borderRadius:
//                                                       BorderRadius.only(
//                                                     topLeft:
//                                                         Radius.circular(5.r),
//                                                     bottomLeft:
//                                                         Radius.circular(5.r),
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: 5.w,
//                                               ),
//                                               Expanded(
//                                                 child: Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     Row(
//                                                       children: [
//                                                         Text(
//                                                             data[index]['name'],
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .ellipsis,
//                                                             style: Theme.of(
//                                                                     context)
//                                                                 .textTheme
//                                                                 .titleMedium!),
//                                                       ],
//                                                     ),
//                                                     Text(
//                                                       data[index]['batch'],
//                                                       style: Theme.of(context)
//                                                           .textTheme
//                                                           .titleSmall!,
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                               Text(
//                                                 "${data[index]['quantity'].toString()}/${data[index]['unit']}",
//                                                 style: Theme.of(context)
//                                                     .textTheme
//                                                     .titleMedium!,
//                                               ),
//                                               SizedBox(
//                                                 width: 5.w,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         feedbackOffset: const Offset(0, 0),
//                                         onDragStarted: () {
//                                           _isDragging = true;
//                                         },
//                                         childWhenDragging: Padding(
//                                           padding: EdgeInsets.symmetric(
//                                               horizontal: 8.0.w, vertical: 2.h),
//                                           child: DottedBorder(
//                                               strokeWidth: 1,
//                                               dashPattern: const [10, 6],
//                                               radius: Radius.circular(5.r),
//                                               color: Colors.grey.shade500,
//                                               child: SizedBox(
//                                                 width: 240.w,
//                                                 height: 60.h,
//                                               )),
//                                         ),
//                                         data: {
//                                           "nameDoc": "",
//                                           "batch": data[index]['batch'],
//                                           "idDoc": data[index]['idDoc'],
//                                           "dateCome": data[index]['dateCome'],
//                                           "name": data[index]['name'],
//                                           "quantity": data[index]['quantity'],
//                                           "unit": data[index]['unit'],
//                                           "placement": data[index]["placement"]
//                                         },
//                                         onDragEnd: (details) {
//                                           _isDragging = true;
//                                         },
//                                         onDraggableCanceled:
//                                             (velocity, offset) {
//                                           _isDragging = true;
//                                         },
//                                         child: Container(
//                                           height: 60.h,
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(5.r),
//                                             border: Border.all(
//                                                 width: 0.1.w,
//                                                 color: Colors.grey.shade500),
//                                           ),
//                                           width: 240.w,
//                                           child: Row(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.center,
//                                             children: [
//                                               Container(
//                                                 width: 5.w,
//                                                 height: double.infinity,
//                                                 decoration: BoxDecoration(
//                                                   color: SonomaneColor.orange,
//                                                   borderRadius:
//                                                       BorderRadius.only(
//                                                     topLeft:
//                                                         Radius.circular(5.r),
//                                                     bottomLeft:
//                                                         Radius.circular(5.r),
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: 5.w,
//                                               ),
//                                               Expanded(
//                                                 child: Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     Row(
//                                                       children: [
//                                                         Text(
//                                                           data[index]['name'],
//                                                           overflow: TextOverflow
//                                                               .ellipsis,
//                                                           style:
//                                                               Theme.of(context)
//                                                                   .textTheme
//                                                                   .titleMedium!,
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     Text(
//                                                       data[index]['batch'],
//                                                       style: Theme.of(context)
//                                                           .textTheme
//                                                           .titleSmall!,
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                               Text(
//                                                 "${data[index]['quantity'].toString()}/${data[index]['unit']}",
//                                                 style: Theme.of(context)
//                                                     .textTheme
//                                                     .titleMedium!,
//                                               ),
//                                               SizedBox(
//                                                 width: 5.w,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       } else {
//                         return const SizedBox();
//                       }
//                     }),
//               ),
//               SizedBox(
//                 height: 10.h,
//               ),
//               Expanded(
//                 child: StreamBuilder(
//                     stream: placeInventory,
//                     builder: (context, placeInventory) {
//                       if (placeInventory.hasError) {
//                         return Center(
//                           child: Text(
//                             "Error database",
//                             style: Theme.of(context).textTheme.titleMedium,
//                           ),
//                         );
//                       } else if (placeInventory.connectionState ==
//                           ConnectionState.waiting) {
//                         return Center(
//                           child: CircularProgressIndicator(
//                             color: SonomaneColor.primary,
//                           ),
//                         );
//                       }
//                       return ScrollConfiguration(
//                         behavior: NoGlow(),
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           key: _listViewKey,
//                           controller: _scroller,
//                           itemCount: placeInventory.data.docs.length,
//                           itemBuilder: (context, index) {
//                             return Padding(
//                               padding: EdgeInsets.only(left: 15.0.w),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                       width: 0.1.w,
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .outline),
//                                 ),
//                                 width: 250.w,
//                                 height: double.infinity,
//                                 child: Column(
//                                   children: [
//                                     Container(
//                                       height: 45.h,
//                                       decoration: BoxDecoration(
//                                           color: Theme.of(context)
//                                               .colorScheme
//                                               .background),
//                                       child: Padding(
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 10.0.w),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               placeInventory
//                                                   .data.docs[index]['name']
//                                                   .toString(),
//                                               style: Theme.of(context)
//                                                   .textTheme
//                                                   .titleMedium!
//                                                   .copyWith(
//                                                       color: Theme.of(context)
//                                                           .colorScheme
//                                                           .tertiary,
//                                                       fontWeight:
//                                                           FontWeight.w600),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: DragTarget(
//                                         onAccept: (Map data) {
//                                           showDialog(
//                                               context: context,
//                                               builder: (context) {
//                                                 return MoveDialog(
//                                                   docInventoriesFirst:
//                                                       data['nameDoc'],
//                                                   docPlaceFirst: data['idDoc'],
//                                                   docInventoriesLast:
//                                                       placeInventory.data
//                                                           .docs[index]['name'],
//                                                   docPlaceLast: data['idDoc'],
//                                                   batch: data['batch'],
//                                                   idDoc: data['idDoc'],
//                                                   dateCome: data['dateCome'],
//                                                   name: data['name'],
//                                                   quantity: data['quantity'],
//                                                   unit: data['unit'],
//                                                 );
//                                               });
//                                         },
//                                         builder: (BuildContext context,
//                                             List<Object?> candidateData,
//                                             List<dynamic> rejectedData) {
//                                           return InventoryCard(
//                                             namaDoc: placeInventory
//                                                 .data.docs[index]['name'],
//                                             onDragStarted: () {
//                                               _isDragging = true;
//                                             },
//                                             onDragEnd: () {
//                                               _isDragging = true;
//                                             },
//                                             onDraggableCanceled: () {
//                                               _isDragging = true;
//                                             },
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     }),
//               ),
//             ],
//           ),
//           onPointerMove: (PointerMoveEvent event) {
//             if (!_isDragging) {
//               return;
//             }
//             RenderBox render =
//                 _listViewKey.currentContext?.findRenderObject() as RenderBox;
//             Offset position = render.localToGlobal(Offset.zero);
//             double topX = position.dx;
//             double bottomX = topX + render.size.width;

//             const detectedRange = 250;
//             const moveDistance = 3;

//             if (event.position.dx < topX + detectedRange) {
//               var to = _scroller.offset - moveDistance;
//               to = (to < 0) ? 0 : to;
//               _scroller.jumpTo(to);
//             }
//             if (event.position.dx > bottomX - detectedRange) {
//               var to = _scroller.offset + moveDistance;

//               // Cek apakah 'to' melebihi batas kanan
//               var maxScrollExtent = _scroller.position.maxScrollExtent;
//               if (to > maxScrollExtent) {
//                 to = maxScrollExtent;
//               }

//               _scroller.jumpTo(to);
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
