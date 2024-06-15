import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:learnspace/Classes/User.dart';

class Voucher {
  String title = "";
  int price = -1;
  String code = "";
  int value = -1;
  bool isRedeemed = false;
  bool isPurchased = false;
  String voucherProfileLink = "";
  String voucherID = "";

  Voucher(this.voucherID);
  Voucher.getEmpty();

  Future<void> getOtherDataFromID() async {
    DocumentSnapshot voucherDoc = await FirebaseFirestore.instance
        .collection('vouchers')
        .doc(voucherID)
        .get();

    Map<String, dynamic> voucherDataMap =
        voucherDoc.data() as Map<String, dynamic>;

    title = voucherDataMap['title'];
    value = voucherDataMap['value'];
    price = voucherDataMap['price'];
    voucherProfileLink = voucherDataMap['voucherProfileLink'];
  }

  Future<void> getPurchasedOtherDataFromID(LearnSpaceUser owner) async {
    DocumentSnapshot voucherDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(owner.id)
        .collection('vouchers')
        .doc(code)
        .get();

    Map<String, dynamic> voucherDataMap =
        voucherDoc.data() as Map<String, dynamic>;

    //title = voucherDataMap['title'];
    //value = voucherDataMap['value'];
    //price = voucherDataMap['price'];

    isPurchased = true;
    voucherID = voucherDataMap['parentVoucherID'];
    isRedeemed = voucherDataMap['isRedeemed'];

    getOtherDataFromID();
  }

  Future<int> getFreeVoucherAmount() async {
    try {
      // Reference to your Firestore collection
      CollectionReference collectionRef = FirebaseFirestore.instance
          .collection('vouchers')
          .doc(voucherID)
          .collection('voucherCodes');

      // Fetch all documents in the collection
      QuerySnapshot querySnapshot =
          await collectionRef.where('isPurchased', isEqualTo: false).get();

      return querySnapshot.docs.length;
    } catch (e) {
      print("Error fetching document IDs: $e");
      return -1;
    }
  }

  Future<void> purchaseVoucher(LearnSpaceUser buyer) async {
    //need to check voucher existence + balance
    List<String> voucherCodes = [];

    try {
      print(voucherID);
      // Reference to your Firestore collection
      CollectionReference collectionRef = FirebaseFirestore.instance
          .collection('vouchers')
          .doc(voucherID)
          .collection('voucherCodes');

      // Fetch all documents in the collection
      QuerySnapshot querySnapshot =
          await collectionRef.where('isPurchased', isEqualTo: false).get();

      // Iterate through each document and add the document ID to the list
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        voucherCodes.add(doc.id);
        break;
      }

      final data2 = {'isPurchased': true};
      collectionRef.doc(voucherCodes[0]).set(data2);

      //already got vouchercode
    } catch (e) {
      print("Error fetching document IDs: $e");
    }

    final db = FirebaseFirestore.instance;

    final data = {'parentVoucherID': voucherID, 'isRedeemed': false};

    // DocumentReference mainDocRef = db.collection('users').doc(buyer.id);

    // // Reference to the sub-collection
    // CollectionReference subCollectionRef = mainDocRef.collection("vouchers");
    // // Adding data to the sub-collection
    // await subCollectionRef.doc("I9sOkyqvCYVnP3mAHmzL").set(data);

    print(voucherCodes[0]);
    await db
        .collection('users')
        .doc(buyer.id)
        .collection("vouchers")
        .doc(voucherCodes[0])
        .set(data);



  }

}
