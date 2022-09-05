import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  //collection reference
  final CollectionReference messCollection =
      FirebaseFirestore.instance.collection('mess');

  Future createMess(String memberName, int mealCount, double mealRate,
      int totalFoodCost) async {
    return await messCollection.doc(uid).set({
      'members': memberName,
      'mealCount': mealCount,
      'mealRate': mealRate,
      'totalFoodCost': totalFoodCost,
    });
  }

// Future addMessMember(String uid) async  {
//   return await
// }
}
