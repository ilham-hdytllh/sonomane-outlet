import 'package:cloud_firestore/cloud_firestore.dart';

class DailyRewardPointModel {
  String idDoc;
  int day;
  int point;
  String jenis;
  String image;
  DailyRewardPointModel({
    required this.idDoc,
    required this.day,
    required this.point,
    required this.jenis,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": idDoc,
      "day": day,
      "point": point,
      "image": image,
      "jenis": jenis,
    };
  }
}

class DailyRewardVoucherModel {
  final String idDoc;
  final int day;
  final String voucherTitle;
  final String voucherCode;
  final String image;
  final num? limitQty;
  final String discountType;
  final String voucherType;
  num? discountAmount;
  num? discountPercent;
  final num minimumPurchase;
  num? maximumDiscount;
  final String createdAt;
  final String? startDate;
  final String? expiredDate;
  final List<String> caraKerja;
  final List<String> syaratKetentuan;
  final bool used;
  final String? level;
  final List? item;
  final num? price;
  final num? masaBerlaku;
  final String jenis;
  DailyRewardVoucherModel({
    required this.idDoc,
    required this.day,
    required this.voucherTitle,
    required this.voucherCode,
    required this.image,
    this.limitQty,
    required this.discountType,
    required this.voucherType,
    this.discountAmount,
    this.discountPercent,
    required this.minimumPurchase,
    this.maximumDiscount,
    required this.createdAt,
    this.startDate,
    this.expiredDate,
    required this.caraKerja,
    required this.syaratKetentuan,
    required this.used,
    this.level,
    this.item,
    this.price,
    this.masaBerlaku,
    required this.jenis,
  });

  Map<String, dynamic> toMap() {
    if (discountType == "percent") {
      return {
        "id": idDoc,
        "day": day,
        "voucherTitle": voucherTitle,
        "voucherCode": voucherCode,
        "image": image,
        "limitQty": limitQty,
        "discountType": discountType,
        "voucherType": voucherType,
        "discountPercent": discountPercent,
        "minimumPurchase": minimumPurchase,
        "maximumDiscount": maximumDiscount,
        "createdAt": createdAt,
        "startDate": startDate,
        "expiredDate": expiredDate,
        "caraKerja": caraKerja,
        "syaratKetentuan": syaratKetentuan,
        "used": used,
        "jenis": "voucher",
      };
    } else if (discountType == "amount") {
      return {
        "id": idDoc,
        "day": day,
        "voucherTitle": voucherTitle,
        "voucherCode": voucherCode,
        "image": image,
        "limitQty": limitQty,
        "discountType": discountType,
        "voucherType": voucherType,
        "discountAmount": discountAmount,
        "minimumPurchase": minimumPurchase,
        "createdAt": createdAt,
        "startDate": startDate,
        "expiredDate": expiredDate,
        "caraKerja": caraKerja,
        "syaratKetentuan": syaratKetentuan,
        "used": used,
        "jenis": "voucher",
      };
    } else {
      return {
        "id": idDoc,
        "day": day,
        "voucherTitle": voucherTitle,
        "voucherCode": voucherCode,
        "image": image,
        "limitQty": limitQty,
        "discountType": discountType,
        "voucherType": voucherType,
        "minimumPurchase": minimumPurchase,
        "createdAt": createdAt,
        "startDate": startDate,
        "expiredDate": expiredDate,
        "caraKerja": caraKerja,
        "syaratKetentuan": syaratKetentuan,
        "used": used,
        "item": item,
        "jenis": "voucher",
      };
    }
  }
}

class DailyRewardFunction {
  final dynamic dailyRewardModel;
  final String jenis;
  DailyRewardFunction({
    required this.dailyRewardModel,
    required this.jenis,
  });

  Stream<QuerySnapshot> getDailyReward() {
    return FirebaseFirestore.instance
        .collection("rewardMisiDaily")
        .orderBy('jenis', descending: false)
        .orderBy('day', descending: false)
        .snapshots();
  }

  Future updateDailyReward(String idDoc) {
    return FirebaseFirestore.instance
        .collection("rewardMisiDaily")
        .doc(idDoc)
        .update(dailyRewardModel.toMap());
  }

  Future addDailyReward(String idDoc) {
    return FirebaseFirestore.instance
        .collection("rewardMisiDaily")
        .doc(idDoc)
        .set(dailyRewardModel.toMap());
  }

  Future deleteDailyReward(String idDoc) {
    return FirebaseFirestore.instance
        .collection("rewardMisiDaily")
        .doc(idDoc)
        .delete();
  }
}
