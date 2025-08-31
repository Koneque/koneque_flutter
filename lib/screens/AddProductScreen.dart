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
                title: const Text("Tomar foto"),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _images.add(File(pickedFile.path));
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Elegir de galería"),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.gallery);
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Borrador guardado (UI simulado)")),
    );
  }

  void _submitProduct() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Producto enviado (UI simulado)")),
      );

      // limpiar formulario
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
        title: const Text("Registrar Producto"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 📸 Imágenes
              _buildCard(
                title: "Imágenes",
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
                        child: Icon(Icons.add_a_photo,
                            size: 40, color: Colors.grey),
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
                                  child: const Icon(Icons.close,
                                      size: 18, color: Colors.white),
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

              // 📝 Información básica
              _buildCard(
                title: "Información básica",
                icon: Icons.info_outline,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                        labelText: "Nombre del producto *"),
                    validator: (v) => v!.isEmpty ? "Ingresa un nombre" : null,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration:
                        const InputDecoration(labelText: "Descripción *"),
                    validator: (v) =>
                        v!.isEmpty ? "Ingresa una descripción" : null,
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Categoría *"),
                    value: _category,
                    items: const [
                      DropdownMenuItem(
                          value: "tecnologia", child: Text("Tecnología")),
                      DropdownMenuItem(value: "moda", child: Text("Moda")),
                      DropdownMenuItem(
                          value: "deportes", child: Text("Deportes")),
                      DropdownMenuItem(value: "hogar", child: Text("Hogar")),
                    ],
                    onChanged: (value) => setState(() => _category = value),
                    validator: (v) =>
                        v == null ? "Selecciona una categoría" : null,
                  ),
                  TextFormField(
                    controller: _stockController,
                    decoration:
                        const InputDecoration(labelText: "Cantidad en stock"),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _skuController,
                    decoration:
                        const InputDecoration(labelText: "SKU / Código único"),
                  ),
                  TextFormField(
                    controller: _tagsController,
                    decoration: const InputDecoration(
                        labelText: "Etiquetas (ej. gamer, portátil)"),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 💰 Precio
              _buildCard(
                title: "Precio",
                icon: Icons.attach_money,
                children: [
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: "Precio *",
                      prefixText: _currency == "USD" ? "\$ " : "",
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? "Ingresa un precio" : null,
                  ),
                  DropdownButtonFormField<String>(
                    value: _currency,
                    decoration: const InputDecoration(labelText: "Moneda"),
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

              const SizedBox(height: 16),

              const SizedBox(height: 24),

              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _saveDraft,
                      child: const Text("Guardar borrador"),
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
                      child: const Text("Enviar producto"),
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
            Row(children: [
              Icon(icon, color: primaryColor),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}
