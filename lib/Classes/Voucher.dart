import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Voucher {
  String title = "";
  int price = -1;
  String code = "";
  int value = -1;
  bool isRedeemed = false;
  String voucherProfileLink = "";
  String voucherID = "";

  Voucher(this.voucherID);
  Voucher.getEmpty();

  Future<void> getOtherDataFromID() async {
    final ref = FirebaseDatabase.instance.ref();

    DocumentSnapshot voucherDoc = await FirebaseFirestore.instance
        .collection('vouchers')
        .doc(voucherID)
        .get();

    Map<String, dynamic> voucherDataMap =
        voucherDoc.data() as Map<String, dynamic>;

    //continue
  }
}
