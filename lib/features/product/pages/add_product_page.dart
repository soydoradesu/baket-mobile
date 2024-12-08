import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  int _price = 0;
  String _specs = "";
  String _category = 'smartphone';
  File? _image;
  final ImagePicker _picker = ImagePicker();

  final List<String> _categories = [
    'smartphone',
    'laptop',
    'tablet',
    'smartwatch',
    'television',
  ];

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image selected successfully!")),
        );
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking image: $e")),
      );
    }
  }

  // Function to submit the form
  Future<void> _submitForm(CookieRequest request) async {
    if (_formKey.currentState!.validate()) {
      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select an image")),
        );
        return;
      }

      try {
        var uri = Uri.parse('http://localhost:8000/catalogue/add-product-api/');
        var requestMultipart = http.MultipartRequest('POST', uri);
        requestMultipart.fields['name'] = _name;
        requestMultipart.fields['price'] = _price.toString();
        requestMultipart.fields['category'] = _category;
        requestMultipart.fields['specs'] = _specs;

        // Add the image file
        requestMultipart.files.add(
          await http.MultipartFile.fromPath(
            'image',
            _image!.path,
          ),
        );

        // Construct the Cookie header from the cookies map
        if (request.cookies.isNotEmpty) {
          String cookieHeader = request.cookies.entries
              .map((e) => "${e.key}=${e.value}")
              .join("; ");
          requestMultipart.headers['Cookie'] = cookieHeader;
        }

        // Send the request
        var streamedResponse = await requestMultipart.send();

        // Get the response
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 201) {
          // Successfully created
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Product added successfully!")),
          );
          Navigator.pop(context, true); // Go back to the product page
        } else {
          // Error occurred
          var responseData = json.decode(response.body);
          String errorMessage =
              responseData['error']?.toString() ?? 'Unknown error occurred';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: $errorMessage")),
          );
        }
      } catch (e) {
        print('Error sending request: $e');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: $e")),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
        backgroundColor: const Color(0xFF01aae8),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _name = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Product name cannot be empty!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                // Price
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (String? value) {
                    setState(() {
                      _price = int.tryParse(value!) ?? 0;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Price cannot be empty!";
                    }
                    if (int.tryParse(value) == null) {
                      return "Price must be a number!";
                    }
                    if (int.tryParse(value)! <= 0) {
                      return "Price must be positive!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                // Specifications
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Specifications',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  maxLines: 5,
                  onChanged: (String? value) {
                    setState(() {
                      _specs = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Specifications cannot be empty!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                // Category Dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  value: _category,
                  items: _categories.map((String category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(
                          category[0].toUpperCase() + category.substring(1)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _category = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                // Image Picker
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate,
                          color:
                              _image == null ? Colors.grey[600] : Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        _image == null ? "Select Image" : "Image Selected",
                        style: TextStyle(
                            color: _image == null
                                ? Colors.grey[600]
                                : Colors.green),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
                // Save Product Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF01aae8),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () => _submitForm(request),
                    child: const Text(
                      "Save Product",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
