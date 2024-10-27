import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/alert.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/customToast.dart';
import 'package:sonomaneoutlet/model/employe/employe.dart';
import 'package:sonomaneoutlet/model/role/role_model.dart';
import 'package:sonomaneoutlet/services/api_base_helper.dart';
import 'package:sonomaneoutlet/shared_widget/app_bar.dart';
import 'package:sonomaneoutlet/shared_widget/button.dart';
import 'package:sonomaneoutlet/shared_widget/dropdown.dart';
import 'package:sonomaneoutlet/shared_widget/footer.dart';
import 'package:sonomaneoutlet/shared_widget/formField.dart';

class UpdateEmploye extends StatefulWidget {
  final String name;
  final String email;
  final String role;
  final String idDoc;
  final String createdAt;
  const UpdateEmploye(
      {super.key,
      required this.name,
      required this.email,
      required this.role,
      required this.idDoc,
      required this.createdAt});

  @override
  State<UpdateEmploye> createState() => _UpdateEmployeState();
}

class _UpdateEmployeState extends State<UpdateEmploye> {
  Future? _dataRole;
  final ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  bool _uploading = false;

  // formkey
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _selectedRole = 'manajer';
  final _passAdminController = TextEditingController();
  final _name = TextEditingController();
  final _email = TextEditingController();

  // update pegawai
  Future updatePegawai() async {
    if (_name.text.isNotEmpty &&
        _email.text.isNotEmpty &&
        _selectedRole.isNotEmpty) {
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
                          isLoading: _uploading,
                          title: "Update Employe",
                          onTap: () async {
                            setState(() {
                              _uploading = true;
                            });
                            String emailAdminNow =
                                FirebaseAuth.instance.currentUser!.email!;

                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                email: emailAdminNow,
                                password: _passAdminController.text,
                              );

                              EmployeModel employeModel = EmployeModel(
                                  email: _email.text,
                                  name: _name.text,
                                  role: _selectedRole,
                                  uid: widget.idDoc,
                                  createdAt: widget.createdAt);
                              await EmployeModelFunction()
                                  .updateEmploye(employeModel, widget.idDoc);
                              setState(() {
                                _uploading = false;
                              });
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pop();
                              // ignore: use_build_context_synchronously
                              CustomToast.successToast(
                                  context, "Berhasil update employe");
                            } catch (e) {
                              setState(() {
                                _uploading = false;
                              });
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pop();
                              // ignore: use_build_context_synchronously
                              Notifikasi.erorAlert(
                                  context, "Password anda salah.");
                            }
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
    } else {
      Notifikasi.erorAlert(context, 'Mohon isi semua data terlebih dahulu');
    }
  }

  _addController() {
    _name.text = widget.name;
    _email.text = widget.email;
    _selectedRole = widget.role;
  }

  @override
  void initState() {
    super.initState();
    _dataRole = RoleModelFunction().getRole();
    _addController();
  }

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
                      'Update Employe',
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
                                    title: 'Username',
                                    textEditingController: _name,
                                    hintText: "Username...",
                                    textInputType: TextInputType.text,
                                  ),
                                  CustomFormField(
                                    readOnly: true,
                                    title: 'Email',
                                    textEditingController: _email,
                                    hintText: "Email...",
                                    textInputType: TextInputType.emailAddress,
                                  ),
                                  FutureBuilder(
                                      future: _dataRole,
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.hasError) {
                                          return Text(
                                            "Error Database",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          );
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CustomDropdown(
                                            title: "Role",
                                            data: const ["manajer"],
                                            hintText: "Select Role",
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedRole = value!;
                                              });
                                            },
                                            textNow: _selectedRole,
                                          );
                                        }
                                        List<String> role = [];
                                        snapshot.data.docs.map((e) {
                                          role.add(
                                            e.data()['role'],
                                          );
                                        }).toList();
                                        return CustomDropdown(
                                          title: "Role",
                                          data: role,
                                          hintText: "Select Role",
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedRole = value!;
                                            });
                                          },
                                          textNow: _selectedRole,
                                        );
                                      }),
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
                                          isLoading: false,
                                          title: "Update Employe",
                                          onTap: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              await updatePegawai();
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
                                          onTap: _uploading == false
                                              ? () async {
                                                  setState(() {
                                                    _name.clear();
                                                    _email.clear();
                                                  });
                                                }
                                              : () {},
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
