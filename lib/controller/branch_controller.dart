// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_application_1/model/branch_model.dart';
// import 'package:get/get.dart';


// class BranchController extends GetxController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final RxList<BranchModel> branches = <BranchModel>[].obs; 

//   @override
//   void onInit() {
//     super.onInit();
//     fetchBranches();
//   }

//   Stream<QuerySnapshot<Map<String, dynamic>>> getBranchesStream() {
//     return _firestore.collection('branches').snapshots();
//   }

//   Future<void> fetchBranches() async {
//     try {
//       QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
//           .collection('branches')
//           .get();
//       branches.addAll(
//           snapshot.docs.map((doc) => BranchModel.fromFirestore(doc, null)).toList());
//     } catch (e) {
//       print("Error fetching branches: ${e.toString()}");
//     }
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/model/branch_model.dart';
import 'package:get/get.dart';

class BranchController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<BranchModel> branches = <BranchModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBranches();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getBranchesStream() {
    return _firestore.collection('branches').snapshots();
  }

  Future<void> fetchBranches() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('branches')
          .get();
      branches.addAll(
          snapshot.docs.map((doc) => BranchModel.fromFirestore(doc, null)).toList());
    } catch (e) {
      print("Error fetching branches: ${e.toString()}");
    }
  }
}