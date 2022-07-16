import 'package:amazon_app/common/widgets/loader.dart';
import 'package:amazon_app/features/account/widgets/single_product.dart';
import 'package:amazon_app/features/admin/screens/add_product_screen.dart';
import 'package:amazon_app/features/admin/services/admin_services.dart';
import 'package:amazon_app/models/product.dart';
import 'package:flutter/material.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final AdminServices adminServices = AdminServices();
  List<Product>? products;
  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  fetchProducts() async {
    products = await adminServices.fetchAllProduct(context: context);
    setState(() {});
  }

  void deleteProduct(Product product, int index) {
    adminServices.deleteProduct(
      context: context,
      product: product,
      onSuccess: () {
        products!.removeAt(index);
        setState(() {});
      },
    );
  }

  void navigateToAddProduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return products == null
        ? const Loader()
        : Scaffold(
            body: GridView.builder(
                itemCount: products!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  final productData = products![index];
                  return Builder(builder: (context) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: 140,
                          child: SingleProduct(imageUrl: productData.images[0]),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Text(
                                productData.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                deleteProduct(productData, index);
                              },
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ],
                        )
                      ],
                    );
                  });
                }),
            floatingActionButton: FloatingActionButton(
              onPressed: navigateToAddProduct,
              child: const Icon(Icons.add),
              tooltip: "Add a Product",
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
