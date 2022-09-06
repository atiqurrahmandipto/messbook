import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  //collection reference
  final CollectionReference messCollection =
      FirebaseFirestore.instance.collection('mess');
  final CollectionReference membersCollection =
      FirebaseFirestore.instance.collection('members');

  Future createMess(String messName, int mealCount, double mealRate,
      int totalFoodCost) async {
    return await messCollection.doc(uid).set({
      'messName': messName,
      'mealCount': mealCount,
      'mealRate': mealRate,
      'totalFoodCost': totalFoodCost,
    });
  }

  Future joinMess(String messUID) async {
    //messUID is mess manager's uid
    return await membersCollection.doc(uid).set({
      'messID': messUID,
    });
  }
}
