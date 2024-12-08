import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../widgets/product_card.dart';
import 'add_product_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  // State variables for search and filters
  String searchQuery = '';
  List<String> selectedCategories = [];
  String? sortOption;

  // List of available categories (should match Django's CATEGORY_CHOICES)
  final List<String> categories = [
    'smartphone',
    'laptop',
    'tablet',
    'smartwatch',
    'television',
  ];

  // Fetch products with query parameters
  Future<List<Product>> fetchProducts(CookieRequest request) async {
    try {
      print('Fetching products with query: $searchQuery, categories: $selectedCategories, sort: $sortOption');
      
      // Build query parameters
      Map<String, dynamic> queryParams = {};
      if (searchQuery.isNotEmpty) {
        queryParams['q'] = searchQuery;
      }
      if (selectedCategories.isNotEmpty) {
        queryParams['category'] = selectedCategories;
      }
      if (sortOption != null && sortOption!.isNotEmpty) {
        queryParams['sort'] = sortOption;
      }

      // Convert query parameters to URL
      Uri uri = Uri.parse('http://localhost:8000/catalogue/prod-json/').replace(queryParameters: {
        ...queryParams.map((key, value) => MapEntry(key, value is List ? value.join(',') : value)),
      });

      print('Fetching from URL: $uri');
      var response = await request.get(uri.toString());
      print('Full response: $response');
      
      if (response == null) {
        print('Response is null');
        return [];
      }

      if (!response.containsKey('products')) {
        print('Response does not contain products key');
        print('Response keys: ${response.keys}');
        return [];
      }

      List<dynamic> jsonList = response['products'];
      print('JsonList length: ${jsonList.length}');
      print('First item in jsonList: ${jsonList.isNotEmpty ? jsonList.first : "empty"}');

      List<Product> products = [];
      for (var item in jsonList) {
        print('Processing item: $item');
        products.add(Product.fromJson(item));
      }
      
      print('Processed products length: ${products.length}');
      return products;
    } catch (e, stackTrace) {
      print('Error fetching products: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Catalogue'),
        backgroundColor: const Color(0xFF01aae8),
      ),
      body: Column(
        children: [
          // Add Product Button (for admin)
          // if (request.loggedIn && request.jsonData?['is_staff'] == true)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddProductPage()),
                  );
                  if (result == true) {
                    // Product was added successfully, refresh the list
                    setState(() {});
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF01aae8),
                  minimumSize: const Size(double.infinity, 40),
                ),
                child: const Text(
                  'Add New Product',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

          // Search and Filter Row
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Search Bar
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari Barang',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    onSubmitted: (value) {
                      setState(() {});
                    },
                  ),
                ),
                // Filter Button
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: StatefulBuilder(
                              builder: (BuildContext context,
                                  StateSetter setModalState) {
                                return Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 400,
                                    maxHeight: 600,
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Filter Options',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.close),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                          ],
                                        ),
                                        const Divider(),
                                        const Text(
                                          'Sort by Price',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        RadioListTile<String>(
                                          title: const Text('Harga paling rendah'),
                                          value: 'price_asc',
                                          groupValue: sortOption,
                                          onChanged: (value) {
                                            setModalState(() {
                                              sortOption = value;
                                            });
                                            setState(() {});
                                          },
                                        ),
                                        RadioListTile<String>(
                                          title: const Text('Harga paling tinggi'),
                                          value: 'price_desc',
                                          groupValue: sortOption,
                                          onChanged: (value) {
                                            setModalState(() {
                                              sortOption = value;
                                            });
                                            setState(() {});
                                          },
                                        ),
                                        const Divider(),
                                        const Text(
                                          'Categories',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        ...categories.map((category) {
                                          return CheckboxListTile(
                                            title: Text(
                                              category[0].toUpperCase() +
                                                  category.substring(1),
                                            ),
                                            value: selectedCategories
                                                .contains(category),
                                            onChanged: (bool? value) {
                                              setModalState(() {
                                                if (value == true) {
                                                  selectedCategories.add(category);
                                                } else {
                                                  selectedCategories
                                                      .remove(category);
                                                }
                                              });
                                              setState(() {});
                                            },
                                          );
                                        }),
                                        const SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                setModalState(() {
                                                  sortOption = null;
                                                  selectedCategories.clear();
                                                });
                                                setState(() {});
                                              },
                                              child: const Text('Reset'),
                                            ),
                                            const SizedBox(width: 8),
                                            ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xFF01aae8),
                                              ),
                                              child: const Text(
                                                'Apply',
                                                style:
                                                    TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Product Grid
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: fetchProducts(request),
              builder: (context, snapshot) {
                // Add debug prints for snapshot state
                print('Connection state: ${snapshot.connectionState}');
                print('Has error: ${snapshot.hasError}');
                print('Has data: ${snapshot.hasData}');
                if (snapshot.hasData) {
                  print('Data length: ${snapshot.data!.length}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  print('Error in snapshot: ${snapshot.error}');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: ${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {}); // This will trigger a rebuild
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No products found'));
                }

                final products = snapshot.data!;
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  padding: const EdgeInsets.all(10),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: products[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
