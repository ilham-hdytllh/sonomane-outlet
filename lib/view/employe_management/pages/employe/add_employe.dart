import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/alert.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:sonomaneoutlet/common/customToast.dart';
import 'package:sonomaneoutlet/model/role/role_model.dart';
import 'package:sonomaneoutlet/services/api_base_helper.dart';
import 'package:sonomaneoutlet/services/base_url.dart';
import 'package:sonomaneoutlet/shared_widget/app_bar.dart';
import 'package:sonomaneoutlet/shared_widget/button.dart';
import 'package:sonomaneoutlet/shared_widget/dropdown.dart';
import 'package:sonomaneoutlet/shared_widget/footer.dart';
import 'package:sonomaneoutlet/shared_widget/formField.dart';

class AddEmploye extends StatefulWidget {
  const AddEmploye({super.key});

  @override
  State<AddEmploye> createState() => _AddEmployeState();
}

class _AddEmployeState extends State<AddEmploye> {
  Future? _dataRole;
  final ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  bool _uploading = false;

  // formkey
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _selectedRole = 'manajer';
  final _passAdminController = TextEditingController();
  final _name = TextEditingController();
  final _email = TextEditingController();

  // Proses add pegawai
  Future prosesAddPegawai() async {
    if (_passAdminController.text.isNotEmpty) {
      try {
        String emailAdminNow = FirebaseAuth.instance.currentUser!.email!;

        // UserCredential userCredentialAdmin =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAdminNow,
          password: _passAdminController.text,
        );
        // ignore: use_build_context_synchronously
        final response = await apiBaseHelper.post(
          "$baseUrl/auth/addAccount",
          {
            "name": _name.text,
            "email": _email.text,
            "role": _selectedRole,
            "password": "password",
          },
          context,
        );

        if (response["status_code"] == 201) {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
          // ignore: use_build_context_synchronously
          CustomToast.successToast(context, "Sukses Menambahkan employe");
        } else {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
          // ignore: use_build_context_synchronously
          CustomToast.errorToast(context, "Gagal menambahkan employe");
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          // ignore: use_build_context_synchronously
          Notifikasi.warningAlert(context, 'Password minimal 6 huruf');
        } else if (e.code == 'email-already-in-use') {
          // ignore: use_build_context_synchronously
          Notifikasi.warningAlert(context,
              'email ini sudah terdaftar sebagai pegawai, silahkan gunakan email lainnya');
        } else if (e.code == 'wrong-password') {
          // ignore: use_build_context_synchronously
          Notifikasi.erorAlert(context, "Password yang anda masukkan salah");
        } else {
          // ignore: use_build_context_synchronously
          Notifikasi.warningAlert(context, e.code);
        }
      } catch (_) {
        // ignore: use_build_context_synchronously
        Notifikasi.warningAlert(context, 'Tidak dapat menambahkan pegawai.');
      }
    } else {
      Notifikasi.warningAlert(context, 'Password tidak boleh kosong!');
    }
  }

  // Add pegawai
  Future addPegawai() async {
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
                          title: "Add Employe",
                          onTap: () async {
                            setState(() {
                              _uploading = true;
                            });
                            await prosesAddPegawai();
                            setState(() {
                              _uploading = false;
                            });
                            // ignore: use_build_context_synchronously
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
    } else {
      Notifikasi.erorAlert(context, 'Mohon isi semua data terlebih dahulu');
    }
  }

  @override
  void initState() {
    super.initState();
    _dataRole = RoleModelFunction().getRole();
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
                      'Add Employe',
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
                                    readOnly: false,
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
                                          title: "Add Employe",
                                          onTap: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              await addPegawai();
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
