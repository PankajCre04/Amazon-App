import 'dart:convert';
import 'package:amazon_app/constants/error_handling.dart';
import 'package:amazon_app/constants/utils.dart';
import 'package:amazon_app/models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../constants/global_variables.dart';
import '../../../providers/user_provider.dart';

class HomeServices {
  Future<List<Product>> fetchCategoryProduct({
    required BuildContext context,
    required String category,
  }) async {
    final userProider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http.get(
        Uri.parse("${uri}api/products?category=$category"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProider.user.token
        },
      );

      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            productList.add(
              Product.fromJson(
                jsonEncode(jsonDecode(res.body)[i]),
              ),
            );
          }
        },
      );
    } catch (error) {
      showSnackBar(context, error.toString());
    }
    return productList;
  }

  Future<Product> fetchDealOfDay({
    required BuildContext context,
  }) async {
    final userProider = Provider.of<UserProvider>(context, listen: false);
    Product product = Product(
      name: "",
      description: "",
      quantity: 0,
      images: [],
      category: "",
      price: 0,
    );
    try {
      http.Response res = await http.get(
        Uri.parse("${uri}api/deal-of-day"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProider.user.token
        },
      );

      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          product = Product.fromJson(res.body);
        },
      );
    } catch (error) {
      showSnackBar(context, error.toString());
    }
    return product;
  }
}
