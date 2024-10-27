import 'package:cloud_firestore/cloud_firestore.dart';

class VoucherGeneralLoyaltyModel {
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
  final num limitPerDay;

  VoucherGeneralLoyaltyModel({
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
    required this.limitPerDay,
  });

  Map<String, dynamic> generaltoMap() {
    if (discountType == "percent") {
      return {
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
      };
    } else if (discountType == "amount") {
      return {
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
      };
    } else {
      return {
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
      };
    }
  }

  Map<String, dynamic> loyaltytoMap() {
    if (discountType == "percent") {
      return {
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
        "level": level,
        "limitPerDay": limitPerDay,
      };
    } else if (discountType == "amount") {
      return {
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
        "level": level,
        "limitPerDay": limitPerDay,
      };
    } else {
      return {
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
        "level": level,
        "limitPerDay": limitPerDay,
      };
    }
  }

  Map<String, dynamic> subscriptiontoMap() {
    if (discountType == "percent") {
      return {
        "voucherTitle": voucherTitle,
        "voucherCode": voucherCode,
        "image": image,
        "discountType": discountType,
        "voucherType": voucherType,
        "discountPercent": discountPercent,
        "minimumPurchase": minimumPurchase,
        "maximumDiscount": maximumDiscount,
        "createdAt": createdAt,
        "caraKerja": caraKerja,
        "syaratKetentuan": syaratKetentuan,
        "used": used,
        "masaBerlaku": masaBerlaku,
        "price": price,
        "limitPerDay": limitPerDay,
      };
    } else if (discountType == "amount") {
      return {
        "voucherTitle": voucherTitle,
        "voucherCode": voucherCode,
        "image": image,
        "discountType": discountType,
        "voucherType": voucherType,
        "discountAmount": discountAmount,
        "minimumPurchase": minimumPurchase,
        "createdAt": createdAt,
        "caraKerja": caraKerja,
        "syaratKetentuan": syaratKetentuan,
        "used": used,
        "masaBerlaku": masaBerlaku,
        "price": price,
        "limitPerDay": limitPerDay,
      };
    } else {
      return {
        "voucherTitle": voucherTitle,
        "voucherCode": voucherCode,
        "image": image,
        "discountType": discountType,
        "voucherType": voucherType,
        "minimumPurchase": minimumPurchase,
        "createdAt": createdAt,
        "caraKerja": caraKerja,
        "syaratKetentuan": syaratKetentuan,
        "used": used,
        "item": item,
        "masaBerlaku": masaBerlaku,
        "price": price,
        "limitPerDay": limitPerDay,
      };
    }
  }
}

class VoucherModel {
  final String collectionName;

  VoucherModel(this.collectionName);

  Stream<QuerySnapshot> getAllVouchers() {
    return FirebaseFirestore.instance
        .collection('vouchers')
        .doc(collectionName)
        .collection('vouchers')
        .snapshots();
  }

  Future addVoucher(VoucherGeneralLoyaltyModel voucher, String idDoc) async {
    await FirebaseFirestore.instance
        .collection('vouchers')
        .doc(collectionName)
        .collection('vouchers')
        .doc(idDoc)
        .set(
          collectionName == "general"
              ? voucher.generaltoMap()
              : collectionName == "membership"
                  ? voucher.loyaltytoMap()
                  : voucher.subscriptiontoMap(),
        );
  }

  Future updateVoucher(VoucherGeneralLoyaltyModel voucher, String idDoc) async {
    await FirebaseFirestore.instance
        .collection('vouchers')
        .doc(collectionName)
        .collection('vouchers')
        .doc(idDoc)
        .set(
          collectionName == "general"
              ? voucher.generaltoMap()
              : collectionName == "membership"
                  ? voucher.loyaltytoMap()
                  : voucher.subscriptiontoMap(),
        );
  }

  Future deleteVoucher(String idDoc) async {
    await FirebaseFirestore.instance
        .collection('vouchers')
        .doc(collectionName)
        .collection('vouchers')
        .doc(idDoc)
        .delete();
  }
}
