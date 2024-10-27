import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/alert.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/customToast.dart';
import 'package:sonomaneoutlet/common/extension_capitalized.dart';
import 'package:sonomaneoutlet/services/api_base_helper.dart';
import 'package:sonomaneoutlet/services/base_url.dart';
import 'package:sonomaneoutlet/shared_widget/button.dart';
import 'package:sonomaneoutlet/view/employe_management/pages/employe/update_employe.dart';

class ListEmploye extends StatefulWidget {
  final List data;
  const ListEmploye({super.key, required this.data});

  @override
  State<ListEmploye> createState() => _ListEmployeState();
}

class _ListEmployeState extends State<ListEmploye> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      rowsPerPage: _rowsPerPage,
      availableRowsPerPage: const [10],
      onRowsPerPageChanged: (int? value) {
        setState(() {
          _rowsPerPage = value!;
        });
      },
      headingRowColor: MaterialStateColor.resolveWith(
          (states) => Theme.of(context).colorScheme.background),
      headingRowHeight: 50.h,
      dataRowMaxHeight: 48.h,
      dataRowMinHeight: 48.h,
      columns: [
        DataColumn(
          label: Text(
            'No',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Nama',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Email',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Role',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
        DataColumn(
          label: Text(
            'Aksi',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 14.sp),
          ),
        ),
      ],
      source: Paginated(
        data: widget.data,
        context: context,
      ),
    );
  }
}

class Paginated extends DataTableSource {
  BuildContext context;
  List data;
  Paginated({required this.data, required this.context});

  ApiBaseHelper apiBaseHelper = ApiBaseHelper();

  final TextEditingController _passAdminController = TextEditingController();

  void deleteEmploye(String uid) async {
    String emailAdminNow = FirebaseAuth.instance.currentUser!.email!;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAdminNow,
        password: _passAdminController.text,
      );
      // ignore: use_build_context_synchronously
      var response = await apiBaseHelper.post(
          "$baseUrl/auth/deleteAccount",
          {
            "uid": uid,
          },
          context);
      if (response["status_code"] == 200) {
        // ignore: use_build_context_synchronously

        // ignore: use_build_context_synchronously
        CustomToast.successToast(context, "Sukses delete employe");
      } else {
        // ignore: use_build_context_synchronously
        CustomToast.errorToast(context, "Gagal delete employe");
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      Notifikasi.erorAlert(context, "Password anda salah.");
    }
  }

  // Add pegawai
  void alertDeleteEmploye(String uid) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        content: SizedBox(
          width: 250.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Masukkan kata sandi',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(
                height: 10.h,
              ),
              TextField(
                obscureText: true,
                controller: _passAdminController,
              ),
              SizedBox(
                height: 30.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Batal',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontSize: 12.sp),
                    ),
                  ),
                  SizedBox(
                    width: 150.w,
                    child: CustomButton(
                        isLoading: false,
                        title: "Delete Employe",
                        onTap: () {
                          deleteEmploye(uid);

                          Navigator.of(context).pop();
                        },
                        color: SonomaneColor.containerLight,
                        bgColor: SonomaneColor.primary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  DataRow getRow(int index) {
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          SizedBox(
            child: Text(
              (index + 1).toString(),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp),
            ),
          ),
        ),
        DataCell(Text(
          data[index]['name'].toString().capitalize(),
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['email'],
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(Text(
          data[index]['role'],
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp),
        )),
        DataCell(
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UpdateEmploye(
                        name: data[index]["name"],
                        email: data[index]["email"],
                        role: data[index]["role"],
                        idDoc: data[index]["idDoc"],
                        createdAt: data[index]["createdAt"],
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: SonomaneColor.orange,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  width: 35,
                  height: 35,
                  child: Icon(
                    Icons.create,
                    color: SonomaneColor.textTitleDark,
                    size: 15,
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () {
                  alertDeleteEmploye(data[index]["idDoc"]);
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      color: SonomaneColor.primary),
                  width: 35,
                  height: 35,
                  child: Icon(
                    Icons.delete,
                    color: SonomaneColor.textTitleDark,
                    size: 15.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
