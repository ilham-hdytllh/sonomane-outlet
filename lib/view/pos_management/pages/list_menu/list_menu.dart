import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sonomaneoutlet/common/behavior.dart';
import 'package:sonomaneoutlet/model/menu/menu.dart';
import 'package:sonomaneoutlet/model/menu_category/menu_category.dart';
import 'package:sonomaneoutlet/shared_widget/custom_dropdown_notitle.dart';
import 'package:sonomaneoutlet/shared_widget/dropdownWaiting.dart';
import 'package:sonomaneoutlet/shared_widget/search.dart';
import 'package:sonomaneoutlet/view/pos_management/widget/card_menu.dart';

class ListMenu extends StatefulWidget {
  const ListMenu({super.key});

  @override
  State<ListMenu> createState() => _ListMenuState();
}

class _ListMenuState extends State<ListMenu> {
  String _selectedKategori = 'semua';
  final TextEditingController _searchDataController = TextEditingController();

  Stream? category;
  Stream? semuamenu;

  @override
  void initState() {
    super.initState();
    category = CategoryFunction().getAllCategory();
    semuamenu = MenuFunction().getAllMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 55.h,
          alignment: Alignment.centerLeft,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5.r),
                topRight: Radius.circular(5.r),
              ),
              color: Theme.of(context).colorScheme.secondaryContainer),
          child: Padding(
            padding: EdgeInsets.only(left: 13.0.w),
            child: Text(
              "Daftar Menu",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                  stream: category,
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasError) {
                      return Expanded(
                          child: DropdownWaiting(hintText: "Semua"));
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Expanded(
                          child: DropdownWaiting(hintText: "Semua"));
                    } else if (snapshot.data.docs.isNotEmpty) {
                      List<String> data = [];
                      snapshot.data.docs.map((e) {
                        data.add(e.data()['name']);
                      }).toList();
                      return CustomDropdownNoTitle(
                        onChanged: (value) {
                          setState(() {
                            _selectedKategori = value!;
                          });
                        },
                        data: data,
                        hintText: "Semua",
                      );
                    } else {
                      return Expanded(
                          child: DropdownWaiting(hintText: "Semua"));
                    }
                  }),
              SizedBox(
                width: 45.w,
              ),
              Expanded(
                child: CustomSearch(
                  controller: _searchDataController,
                  hintText: 'Cari menu disini..',
                  keyboardType: TextInputType.text,
                  readOnly: false,
                  onChanged: (String value) {
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Expanded(
          child: ScrollConfiguration(
            behavior: NoGloww(),
            child: SingleChildScrollView(
              child: StreamBuilder(
                stream: semuamenu,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("eror"),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Wrap(
                      runSpacing: 13,
                      spacing: 13,
                      children: [
                        for (int a = 0; a < 12; a++) ...{
                          SizedBox(
                            width: 182.w,
                            height: 248.h,
                            child: Shimmer.fromColors(
                              baseColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              highlightColor: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              child: const Card(
                                elevation: 0,
                                child: Center(),
                              ),
                            ),
                          ),
                        }
                      ],
                    );
                  } else if (snapshot.data.docs.isNotEmpty) {
                    List<dynamic> filterName({required List<dynamic> data}) {
                      if (_selectedKategori == "semua") {
                        return data.toList(growable: false);
                      } else {
                        return data
                            .where((element) => element["category"]
                                .trim()
                                .toLowerCase()
                                .contains(
                                    _selectedKategori.trim().toLowerCase()))
                            .toList(growable: false);
                      }
                    }

                    List<dynamic> filterNameData(
                        {required List<dynamic> data,
                        required String namaSearchField,
                        required String searchString}) {
                      if (_selectedKategori == "semua") {
                        return data
                            .where((element) => element[namaSearchField]
                                .trim()
                                .toLowerCase()
                                .contains(searchString.trim().toLowerCase()))
                            .toList(growable: false);
                      } else {
                        return data
                            .where((element) => element["category"]
                                .trim()
                                .toLowerCase()
                                .contains(
                                    _selectedKategori.trim().toLowerCase()))
                            .where((element) => element[namaSearchField]
                                .trim()
                                .toLowerCase()
                                .contains(searchString.trim().toLowerCase()))
                            .toList(growable: false);
                      }
                    }

                    final List menuDocs = [];
                    snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map a = document.data() as Map<String, dynamic>;
                      // Tambahkan filter isNotEqualTo di sini
                      if (a['codeBOM'] != "") {
                        menuDocs.add(a);
                        a['id'] = document.id;
                      }
                    }).toList();

                    if (_searchDataController.text.isEmpty) {
                      var filteredHistoryLogData = filterName(
                        data: menuDocs,
                      );
                      return Wrap(
                        runSpacing: 13,
                        spacing: 13,
                        children: [
                          for (int i = 0;
                              i < filteredHistoryLogData.length;
                              i++) ...[
                            FadeInUp(
                              duration: Duration(milliseconds: 400 + (100 * i)),
                              child: CardMenu(
                                id: filteredHistoryLogData[i]['id'],
                                name: filteredHistoryLogData[i]['name'],
                                images: filteredHistoryLogData[i]['images'][0],
                                price: filteredHistoryLogData[i]['price'],
                                subcategory: filteredHistoryLogData[i]
                                    ['subcategory'],
                                category: filteredHistoryLogData[i]['category'],
                                addons: filteredHistoryLogData[i]['addons'],
                                deskripsi: filteredHistoryLogData[i]
                                    ['description'],
                                discount:
                                    filteredHistoryLogData[i]['discount'] ?? 0,
                                kitchenOrBar: filteredHistoryLogData[i]
                                    ['kitchen_or_bar'],
                                codeBOM:
                                    filteredHistoryLogData[i]['codeBOM'] ?? "",
                              ),
                            ),
                          ],
                        ],
                      );
                    } else {
                      var filteredHistoryLogData = filterNameData(
                          data: menuDocs,
                          namaSearchField: "name",
                          searchString: _searchDataController.text.trim());

                      if (filteredHistoryLogData.isNotEmpty) {
                        return Wrap(
                          runSpacing: 13,
                          spacing: 13,
                          children: [
                            for (int i = 0;
                                i < filteredHistoryLogData.length;
                                i++) ...[
                              FadeInUp(
                                duration:
                                    Duration(milliseconds: 400 + (100 * i)),
                                child: CardMenu(
                                  id: filteredHistoryLogData[i]['id'],
                                  name: filteredHistoryLogData[i]['name'],
                                  images: filteredHistoryLogData[i]['images']
                                      [0],
                                  price: filteredHistoryLogData[i]['price'],
                                  subcategory: filteredHistoryLogData[i]
                                      ['subcategory'],
                                  category: filteredHistoryLogData[i]
                                      ['category'],
                                  addons: filteredHistoryLogData[i]['addons'],
                                  deskripsi: filteredHistoryLogData[i]
                                      ['description'],
                                  discount: filteredHistoryLogData[i]
                                          ['discount'] ??
                                      0,
                                  kitchenOrBar: filteredHistoryLogData[i]
                                      ['kitchen_or_bar'],
                                  codeBOM: filteredHistoryLogData[i]['codeBOM'],
                                ),
                              ),
                            ],
                          ],
                        );
                      } else {
                        return SizedBox(
                          height: 350.h,
                          child: Center(
                            child: Text(
                              "Menu tidak ditemukan",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontSize: 18.sp),
                            ),
                          ),
                        );
                      }
                    }
                  } else {
                    return Wrap(
                      runSpacing: 13,
                      spacing: 13,
                      children: [
                        for (int a = 0; a < 12; a++) ...{
                          SizedBox(
                            width: 182.w,
                            height: 248.h,
                            child: Shimmer.fromColors(
                              baseColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              highlightColor: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              child: const Card(
                                elevation: 0,
                                child: Center(),
                              ),
                            ),
                          ),
                        }
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
