import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/my_drawer.dart';
import 'package:flutter_application_1/components/my_sliver_app_bar.dart';
import 'package:flutter_application_1/components/my_tapbar.dart';
import 'package:flutter_application_1/controller/branch_controller.dart';
import 'package:flutter_application_1/controller/branch_product_controller.dart';
import 'package:flutter_application_1/controller/product_controller.dart';
import 'package:flutter_application_1/model/product_modle.dart';
import 'package:flutter_application_1/pages/add_product_page.dart';
import 'package:flutter_application_1/themes/theme_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final String? branchId; // Pass the branch ID to the homepage
  const HomePage({super.key, required this.branchId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ProductController productController = Get.put(ProductController());
  final BranchController branchController = Get.find();
  final BranchesProductController branchesProductController =
      Get.put(BranchesProductController());
  final int outOfStockThreshold = 0;
  final int lowStockThreshold = 5;

  RxList<Product> allProducts = <Product>[].obs;
  RxList<Product> outOfStockProducts = <Product>[].obs;
  RxList<Product> lowStockProducts = <Product>[].obs;

  String selectedCategory = 'All'; // Default selected category
  List<String> categories = ['All', 'Pizza', 'Steak', 'Drink', 'Misc'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    if (widget.branchId != null) {
      productController.selectedBranchId = widget.branchId;
      _fetchProducts();
    }
  }

  void _fetchProducts() {
    if (selectedCategory == 'All') {
      productController.fetchProductsForBranch(widget.branchId!);
    } else {
      productController.fetchProductsForBranchByCategory(
          widget.branchId!, selectedCategory);
    }
    // Update the filtered products based on the current selected category.
    _updateFilteredProducts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateFilteredProducts() {
    allProducts.value = productController.products.toList();
    outOfStockProducts.value = _filterProductsByStock(
        allProducts.toList(), outOfStockThreshold, false);
    lowStockProducts.value =
        _filterProductsByStock(allProducts.toList(), lowStockThreshold, true);
  }

  List<Product> _filterProductsByStock(
      List<Product> products, int threshold, bool isLowStock) {
    return products.where((product) {
      int quantity = int.tryParse(product.quantity.toString()) ?? 0;
      if (isLowStock) {
        return quantity <= lowStockThreshold && quantity > outOfStockThreshold;
      } else {
        return quantity == outOfStockThreshold;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            MySliverAppBar(
              title: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'All'),
                  Tab(text: 'Out of Stock'),
                  Tab(text: 'Low in Stock'),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Pizza Icon
                  Icon(
                    Icons.local_pizza, // Pizza icon
                    size: 120, // Adjust size as needed
                    color: Provider.of<ThemeProvider>(context)
                        .themeData
                        .colorScheme
                        .primary,
                  ),
                  const SizedBox(height: 8), // Spacing between icon and text
                  // Branch Text
                  Text(
                    'Branch: ${widget.branchId}',
                    style: const TextStyle(
                      fontSize: 14, // Larger font size for better visibility
                      fontWeight: FontWeight.bold, // Bold text
                    ),
                    textAlign: TextAlign.center, // Center align text
                  ),
                  Divider(
                    indent: 25,
                    endIndent: 25,
                    color: Provider.of<ThemeProvider>(context)
                        .themeData
                        .colorScheme
                        .secondary,
                  ),
                ],
              ),
              filter: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Filter',
                    style: TextStyle(fontSize: 16),
                  ),
                  Icon(Icons.filter_alt,
                      color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 30),
                  DropdownButton<String>(
                    value: selectedCategory,
                    items: categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue ?? 'All';
                      });
                      // Fetch products based on the selected category
                      _fetchProducts();
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: [
              // All Products Tab
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: productController.productsStream,
                builder: (context, snapshot) {
                  final themeProvider = Provider.of<ThemeProvider>(context);

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No products available'));
                  } else {
                    final productsData = snapshot.data!.docs
                        .map((doc) =>
                            Product.fromMap(doc.data() as Map<String, dynamic>)
                              ..id = doc.id) // Assign the id to the product
                        .toList();

                    // Use the filtered list based on selected category
                    List<Product> displayedProducts = selectedCategory == 'All'
                        ? productsData
                        : productsData
                            .where((product) =>
                                product.category == selectedCategory)
                            .toList();

                    return Container(
                      color: themeProvider.themeData.colorScheme.background,
                      child: _buildProductList(displayedProducts),
                    );
                  }
                },
              ),

              // Out of Stock Tab
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: productController.productsStream,
                builder: (context, snapshot) {
                  final themeProvider = Provider.of<ThemeProvider>(context);

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('No products available'));
                  } else {
                    final productsData = snapshot.data!.docs
                        .map((doc) =>
                            Product.fromMap(doc.data() as Map<String, dynamic>)
                              ..id = doc.id) // Assign the id to the product
                        .toList();
                    // Out of Stock Products
                    final outOfStockProducts = productsData.where((product) {
                      int quantity =
                          int.tryParse(product.quantity.toString()) ?? 0;
                      return quantity == outOfStockThreshold &&
                          (selectedCategory == 'All' ||
                              product.category == selectedCategory);
                    }).toList();

                    return Container(
                      color: themeProvider.themeData.colorScheme.background,
                      child: _buildProductList(outOfStockProducts),
                    );
                  }
                },
              ),
              // Low in Stock Tab
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: productController.productsStream,
                builder: (context, snapshot) {
                  final themeProvider = Provider.of<ThemeProvider>(context);

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('No products available'));
                  } else {
                    final productsData = snapshot.data!.docs
                        .map((doc) =>
                            Product.fromMap(doc.data() as Map<String, dynamic>)
                              ..id = doc.id) // Assign the id to the product
                        .toList();
                    // Low Stock Products
                    final lowStockProducts = productsData.where((product) {
                      int quantity =
                          int.tryParse(product.quantity.toString()) ?? 0;
                      return quantity <= lowStockThreshold &&
                          quantity > outOfStockThreshold &&
                          (selectedCategory == 'All' ||
                              product.category == selectedCategory);
                    }).toList();

                    return Container(
                      color: themeProvider.themeData.colorScheme.background,
                      child: _buildProductList(lowStockProducts),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddProductPage());
        },
        child:
            Icon(Icons.post_add, color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  Widget _buildProductList(List<Product> productsData) {
    return ListView.builder(
      itemCount: productsData.length,
      itemBuilder: (context, index) {
        final product = productsData[index];
        return _buildProductItem(context, product, product.id);
      },
    );
  }

  Widget _buildProductItem(
      BuildContext context, Product product, String productId) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center horizontally
          crossAxisAlignment: CrossAxisAlignment.center, // Center vertically
          children: [
            // Image (replace with a placeholder or actual image)
            SizedBox(
              height: 80,
              width: 80,
              child: Image.network(product.imageUrl),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align text to the left
                mainAxisAlignment: MainAxisAlignment
                    .start, // Start alignment for vertical spacing
                children: [
                  // Title
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.start, // Left align title text
                  ),
                  // Category
                  Text(
                    product
                        .category, // Assuming product has a category property
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey, // You can adjust the color as needed
                    ),
                    textAlign: TextAlign.start, // Left align category text
                  ),
                  // Price
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center, // Center price text
                  ),
                ],
              ),
            ),
            const SizedBox(
                width: 16.0), // Add spacing between price and quantity
            // Quantity
            Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              children: [
                Text(
                  'Quantity',
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.green[200], // Green background
                  ),
                  child: Center(
                    child: Text(
                      '${product.quantity}',
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Update Quantity Button
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Show a dialog to update quantity
                _showUpdateQuantityDialog(context, product.name, productId);
              },
            ),
            // Delete Button
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Delete the product from Firestore
                productController
                    .deleteProduct(productId); // Use the product id
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showUpdateQuantityDialog(
      BuildContext context, String productName, String productId) async {
    final TextEditingController quantityController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Quantity for $productName'),
          content: TextFormField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'New Quantity'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call updateProductQuantity with the new quantity
                productController.updateProductQuantity(
                    productName, productId, quantityController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
