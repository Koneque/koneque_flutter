import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/colors.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  List<File> _images = [];

  bool _featured = false;
  bool _freeShipping = false;
  String _currency = "USD";
  String? _category;

  Future<void> _selectImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take Photo"),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await _picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      _images.add(File(pickedFile.path));
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from Gallery"),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      _images.add(File(pickedFile.path));
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _saveDraft() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Draft saved (UI simulated)")));
  }

  void _submitProduct() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product submitted (UI simulated)")),
      );

      // Clear form
      _titleController.clear();
      _descriptionController.clear();
      _priceController.clear();
      _stockController.clear();
      _skuController.clear();
      _tagsController.clear();

      setState(() {
        _images.clear();
        _featured = false;
        _freeShipping = false;
        _currency = "USD";
        _category = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Product"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 📸 Images
              _buildCard(
                title: "Images",
                icon: Icons.image,
                children: [
                  GestureDetector(
                    onTap: _selectImage,
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add_a_photo,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_images.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(_images.length, (index) {
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                _images[index],
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 2,
                              right: 2,
                              child: GestureDetector(
                                onTap: () => _removeImage(index),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              // 📝 Basic Information
              _buildCard(
                title: "Basic Information",
                icon: Icons.info_outline,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: "Product Name *",
                    ),
                    validator: (v) => v!.isEmpty ? "Enter a name" : null,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Description *",
                    ),
                    validator: (v) => v!.isEmpty ? "Enter a description" : null,
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Category *"),
                    value: _category,
                    items: const [
                      DropdownMenuItem(
                        value: "technology",
                        child: Text("Technology"),
                      ),
                      DropdownMenuItem(
                        value: "fashion",
                        child: Text("Fashion"),
                      ),
                      DropdownMenuItem(value: "sports", child: Text("Sports")),
                      DropdownMenuItem(value: "home", child: Text("Home")),
                    ],
                    onChanged: (value) => setState(() => _category = value),
                    validator: (v) => v == null ? "Select a category" : null,
                  ),
                  TextFormField(
                    controller: _stockController,
                    decoration: const InputDecoration(
                      labelText: "Stock Quantity",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _skuController,
                    decoration: const InputDecoration(
                      labelText: "SKU / Unique Code",
                    ),
                  ),
                  TextFormField(
                    controller: _tagsController,
                    decoration: const InputDecoration(
                      labelText: "Tags (e.g., gamer, laptop)",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 💰 Price
              _buildCard(
                title: "Price",
                icon: Icons.attach_money,
                children: [
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: "Price *",
                      prefixText: _currency == "USD" ? "\$ " : "",
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? "Enter a price" : null,
                  ),
                  DropdownButtonFormField<String>(
                    value: _currency,
                    decoration: const InputDecoration(labelText: "Currency"),
                    items: const [
                      DropdownMenuItem(value: "USD", child: Text("USD (\$)")),
                      DropdownMenuItem(value: "EUR", child: Text("EUR (€)")),
                      DropdownMenuItem(value: "MXN", child: Text("MXN (\$)")),
                      DropdownMenuItem(value: "GBP", child: Text("GBP (£)")),
                    ],
                    onChanged: (value) => setState(() => _currency = value!),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _saveDraft,
                      child: const Text("Save Draft"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text("Submit Product"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}
