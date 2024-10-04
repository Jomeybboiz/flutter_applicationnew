import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/model/branches_product_model.dart';
import 'package:get/get.dart';

class BranchesProductController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<BranchesProductModel> branchesProduct =
      <BranchesProductModel>[].obs;
  String? selectedBranchId; // To hold the selected branch ID

  Future<void> fetchBranchesProducts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('products').get();
      branchesProduct.value = snapshot.docs
          .map((doc) => BranchesProductModel.fromJson(
              doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error fetching products: ${e.toString()}");
    }
  }

  Future<void> fetchProductsForBranch(String branchId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('products')
          .where('branch', isEqualTo: branchId) // Use your new field name
          .get();
      branchesProduct.value = snapshot.docs
          .map((doc) => BranchesProductModel.fromJson(
              doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error fetching products: ${e.toString()}");
    }
  }
}