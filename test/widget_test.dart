

import 'package:flutter/material.dart';
import 'package:learnspace/Classes/Answer.dart';
import 'package:learnspace/Classes/Question.dart';
import 'package:learnspace/Classes/Voucher.dart';
import 'package:learnspace/widgets/AnswerPiece.dart';
import 'package:learnspace/widgets/QuestionCard.dart';
import 'package:learnspace/pages/ShoppingPage.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:nock/nock.dart';
import 'package:flutter_test/flutter_test.dart';




void main() {
  
  //widget test
  testWidgets('Testing voucher card title, price, and voucherleft text based on voucher object',
      (tester) async {
   
    Voucher voucher = Voucher.getEmpty();
    voucher.title = "testTitle";
    voucher.price = 10;
    voucher.code = "testCode";
    voucher.value = 20;
    voucher.voucherProfileLink = "";
    voucher.voucherID = "testID";



    //mocknetworkimage package is used to bypass http error because test can not make real http calls
    await mockNetworkImages(() async => tester.pumpWidget(MaterialApp(
      home: VoucherCard.getVoucher(voucher, 20),
    )));

    final titleFinder = find.text("testTitle");
    final priceFinder = find.text("Price: 10 points");
    final voucherLeftFinder = find.text("Available voucher left: 20");

    expect(titleFinder, findsOneWidget);
    expect(priceFinder, findsOneWidget);
    expect(voucherLeftFinder, findsOneWidget);

  });
}
