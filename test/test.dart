import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learnspace/Classes/User.dart';
import 'package:learnspace/firebase_options.dart';
import 'package:test/test.dart';


void main(){
  //unit test of uploading and retrieving data from firestore, use of fakefirebasefirestore because firestore only works in main
  test("User info should be sent and received correctly", () async {

    final firestore = FakeFirebaseFirestore();

    final test_username = 'hebert';
    final test_email = "tp067551@mail.apu.edu.my";
    final test_profile_picture_url = 'https://firebasestorage.googleapis.com/v0/b/learnspacefirebase.appspot.com/o/user-profile.png?alt=media&token=59e8130d-c794-4125-a83e-22a7482bd81b';
    final test_role = 'Student';
    final test_point = '0';

    await firestore
          .collection('users')
          .doc("abcd")
          .set({
        'username': test_username,
        'email': test_email,
        'profile_picture_url':
            test_profile_picture_url,
        'role': test_role,
        'point': test_point,
      });

    DocumentSnapshot ds = await firestore.collection('users').doc("abcd").get();

    Map<String, dynamic> dataMap = ds.data() as Map<String, dynamic>;

    expect(dataMap['username'], test_username);
    expect(dataMap['email'], test_email);
    expect(dataMap['profile_picture_url'], test_profile_picture_url);
    expect(dataMap['role'], test_role);
    expect(dataMap['point'], test_point);
  });

  

}