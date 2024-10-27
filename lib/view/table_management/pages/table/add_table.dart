import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/customToast.dart';
import 'package:sonomaneoutlet/model/audit/history_log.dart';
import 'package:sonomaneoutlet/model/table/table_model.dart';
import 'package:sonomaneoutlet/shared_widget/app_bar.dart';
import 'package:sonomaneoutlet/shared_widget/button.dart';
import 'package:sonomaneoutlet/shared_widget/dropdown.dart';
import 'package:sonomaneoutlet/shared_widget/footer.dart';
import 'package:sonomaneoutlet/shared_widget/formField.dart';

class AddTable extends StatefulWidget {
  const AddTable({super.key});

  @override
  State<AddTable> createState() => _AddTableState();
}

class _AddTableState extends State<AddTable> {
  bool _uploading = false;

  // formkey
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<String> _locationTable = [
    'A',
    'B',
  ];

  String _selectedtipemeja = 'A';
  final _tableNumber = TextEditingController();
  final _capacityMaks = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child: SonomaneAppBarWidget(),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 5.0.h),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: SizedBox(
                        height: 32,
                        width: 32,
                        child: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          child: Center(
                            child: Icon(
                              Icons.arrow_back,
                              size: 24.sp,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      'Add Table',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 0.1.w,
                          color: Theme.of(context).colorScheme.outline),
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    padding: EdgeInsets.only(top: 30.h, bottom: 30.h),
                    child: ScrollConfiguration(
                      behavior: NoGlow(),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Flex(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                direction: Axis.horizontal,
                                children: [
                                  CustomFormField(
                                    readOnly: false,
                                    title: 'Table Number',
                                    textEditingController: _tableNumber,
                                    hintText: "Table Number...",
                                    textInputType: TextInputType.number,
                                  ),
                                  CustomDropdown(
                                    title: "Table Location",
                                    data: _locationTable,
                                    hintText: "Select Location",
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedtipemeja = value!;
                                      });
                                    },
                                    textNow: _selectedtipemeja,
                                  ),
                                  CustomFormField(
                                    readOnly: false,
                                    title: 'Capacity Max',
                                    textEditingController: _capacityMaks,
                                    hintText: "Capacity Max...",
                                    textInputType: TextInputType.number,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 15.0.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 135.w,
                                      height: 50.h,
                                      child: CustomButton(
                                          isLoading: _uploading,
                                          title: "Add Table",
                                          onTap: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              if (_uploading == false) {
                                                setState(() {
                                                  _uploading = true;
                                                });

                                                try {
                                                  TableModelFunction
                                                      tableModel =
                                                      TableModelFunction();
                                                  TableModel table = TableModel(
                                                      ketersediaan: true,
                                                      maximumCapacity:
                                                          _capacityMaks.text,
                                                      status: "Aktif",
                                                      tableLocation:
                                                          _selectedtipemeja,
                                                      tableNumber:
                                                          "$_selectedtipemeja${_tableNumber.text}");

                                                  DateTime dateTime =
                                                      DateTime.now();

                                                  String idDocHistory =
                                                      "log ${DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime)}";

                                                  HistoryLogModel history =
                                                      HistoryLogModel(
                                                    idDoc: idDocHistory,
                                                    date: dateTime.day,
                                                    month: dateTime.month,
                                                    year: dateTime.year,
                                                    dateTime: DateFormat(
                                                            'yyyy-MM-dd HH:mm:ss')
                                                        .format(dateTime),
                                                    keterangan:
                                                        "Menambahkan list table",
                                                    user: FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .email ??
                                                        "",
                                                    type: "create",
                                                  );

                                                  HistoryLogModelFunction
                                                      historyLogFunction =
                                                      HistoryLogModelFunction(
                                                          idDocHistory);

                                                  await tableModel.addTable(
                                                      table,
                                                      "$_selectedtipemeja${_tableNumber.text}");

                                                  await historyLogFunction
                                                      .addHistory(history,
                                                          idDocHistory);

                                                  setState(() {
                                                    _tableNumber.clear();
                                                    _capacityMaks.clear();
                                                  });
                                                  setState(() {
                                                    _uploading = false;
                                                  });
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.of(context).pop();
                                                  // ignore: use_build_context_synchronously
                                                  CustomToast.successToast(
                                                      context,
                                                      'Table berhasil dibuat!');
                                                } catch (error) {
                                                  setState(() {
                                                    _uploading = false;
                                                  });
                                                  // ignore: use_build_context_synchronously
                                                  CustomToast.errorToast(
                                                      context,
                                                      'Table gagal ditambahkan!');
                                                }
                                              }
                                            }
                                          },
                                          color: SonomaneColor.containerLight,
                                          bgColor: SonomaneColor.primary),
                                    ),
                                    SizedBox(
                                      width: 15.w,
                                    ),
                                    SizedBox(
                                      width: 135.w,
                                      height: 50.h,
                                      child: CustomButton(
                                          isLoading: false,
                                          title: "Clear",
                                          onTap: () async {
                                            setState(() {
                                              _tableNumber.clear();
                                              _capacityMaks.clear();
                                            });
                                          },
                                          color: SonomaneColor.textTitleLight,
                                          bgColor: SonomaneColor.secondary),
                                    ),
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              const SonomaneFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
