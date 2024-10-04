import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/model/product_modle.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<Product> products = <Product>[].obs;
  String? selectedBranchId;

  Future<void> fetchProductsForBranchByCategory(
      String branchId, String category) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('products')
          .where('branch', isEqualTo: branchId)
          .where('category',
              isEqualTo:
                  category) // Assuming you have a 'category' field in Firestore
          .get();

      // Use a Map to store products by their name
      Map<String, Product> productMapByName = {};

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        Product product = Product.fromMap(doc.data() as Map<String, dynamic>)
          ..id = doc.id; // Assign the id to the product

        // Check if the product name already exists in the map
        if (productMapByName.containsKey(product.name)) {
          // If the name exists, update the quantity if it's different
          if (productMapByName[product.name]!.quantity != product.quantity) {
            // Update the quantity in the existing product
            productMapByName[product.name]!.quantity = product.quantity;
          }
        } else {
          // If the name doesn't exist, add the product to the map
          productMapByName[product.name] = product;
        }
      }

      // Update the products list with the values from the map
      products.value = productMapByName.values.toList();
    } catch (e) {
      print("Error fetching products by category: ${e.toString()}");
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> get productsStream => _firestore
      .collection('products')
      .where('branch', isEqualTo: selectedBranchId) // Add where clause
      .snapshots();
  Future<void> fetchProductsForBranch(String branchId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('products')
          .where('branch', isEqualTo: branchId)
          .get();

      // Use a Map to store products by their name
      Map<String, Product> productMapByName = {};

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        Product product = Product.fromMap(doc.data() as Map<String, dynamic>)
          ..id = doc.id; // Assign the id to the product

        // Check if the product name already exists in the map
        if (productMapByName.containsKey(product.name)) {
          // If the name exists, update the quantity if it's different
          if (productMapByName[product.name]!.quantity != product.quantity) {
            // Update the quantity in the existing product
            productMapByName[product.name]!.quantity = product.quantity;
          }
        } else {
          // If the name doesn't exist, add the product to the map
          productMapByName[product.name] = product;
        }
      }

      // Update the products list with the values from the map
      products.value = productMapByName.values.toList();
    } catch (e) {
      print("Error fetching products: ${e.toString()}");
    }
  }

  Future<void> addProduct({
    required String productName,
    required String productQuantity,
    required String productPrice,
    required String branchId,
  }) async {
    try {
      // Add the new product directly to Firestore
      await _firestore.collection('products').add({
        'branch': branchId,
        'p_name': productName,
        'p_price': productPrice,
        'p_quantity': productQuantity,
      });
    } catch (e) {
      print("Error adding product: ${e.toString()}");
    }
  }

  Future<void> updateProductQuantity(
      String productName, String productId, String newQuantity) async {
    try {
      await _firestore
          .collection('products')
          .doc(productId)
          .update({'p_quantity': newQuantity});

      // Re-fetch products after updating
      await fetchProductsForBranch(selectedBranchId!);
    } catch (e) {
      print("Error updating product: ${e.toString()}");
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
    } catch (e) {
      print("Error deleting product: ${e.toString()}");
    }
  }
}
