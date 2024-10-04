import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/widget/drop_down.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  String? selectedCategory;
  String? selectedBranch;
  String? selectedImage;

  // Sample image URLs for selection
  final List<String> imageUrls = [
    'https://ipcdn.freshop.com/resize?url=https://images.freshop.com/00273329000000/56e50355ebb61603fd721c86ea63a626_large.png&width=512&type=webp&quality=90',
    'https://www.foodandwine.com/thmb/4qg95tjf0mgdHqez5OLLYc0PNT4=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/classic-cheese-pizza-FT-RECIPE0422-31a2c938fc2546c9a07b7011658cfd05.jpg',
    'https://www.shutterstock.com/shutterstock/photos/2329440827/display_1500/stock-photo-a-glass-of-coke-with-ice-cubes-isolated-on-white-background-2329440827.jpg',
    'https://images.all-free-download.com/images/graphicwebp/miscellaneous_90471.webp' // Add more image URLs as needed
  ];

  void _addProduct() {
    if (_nameController.text.isEmpty ||
        selectedImage == null ||
        _priceController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        selectedCategory == null ||
        selectedBranch == null) {
      // Show error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final product = {
      'p_name': _nameController.text,
      'imageUrl': selectedImage,
      'price': double.tryParse(_priceController.text) ?? 0.0,
      'category': selectedCategory,
      'p_quantity': _quantityController.text,
      'branch': selectedBranch,
    };

    FirebaseFirestore.instance.collection('products').add(product).then((_) {
      Navigator.of(context).pop(); // Go back to the previous screen
    }).catchError((error) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product')),
      );
    });
  }

  // Function to show the image selection dialog
  void _showImageSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select an Image'),
          content: SizedBox(
            height: 300, // Set height for the image selection dialog
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(
                    imageUrls[index],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text('Product ${index + 1}'),
                  onTap: () {
                    setState(() {
                      selectedImage = imageUrls[index]; // Update selected image
                    });
                    Navigator.of(context).pop(); // Close the dialog
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  label: Text('Product Name'),
                  hintText: 'Enter Product Name',
                ),
              ),
              SizedBox(height: 30),
              // Image selection button
              GestureDetector(
                onTap: _showImageSelectionDialog,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedImage == null
                            ? 'Select Image'
                            : 'Image Selected',
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  label: Text('Quantity'),
                  hintText: 'Enter Quantity',
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  label: Text('Price'),
                  hintText: 'Enter Price of Product',
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              DropDown(
                items: ['Pizza', 'Steak', 'Drink', 'Misc'],
                select: 'Category',
                onSelected: (select) {
                  setState(() {
                    selectedCategory = select;
                  });
                },
              ),
              SizedBox(height: 10),
              DropDown(
                items: [
                  'branch 1',
                  'branch 2',
                  'branch 3',
                  'branch 4',
                  'branch 5',
                  'branch 6',
                  'branch 7'
                ],
                select: 'Branch',
                onSelected: (select) {
                  setState(() {
                    selectedBranch = select;
                  });
                },
              ),
              SizedBox(
                height: 100, // Increase the height of the box to 100
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
                onPressed: _addProduct,
                child: Row(
                  mainAxisSize:
                      MainAxisSize.min, // Keep the button size minimal
                  children: [
                    Icon(Icons.post_add),
                    SizedBox(width: 10),
                    Text(
                      'Add Product',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
