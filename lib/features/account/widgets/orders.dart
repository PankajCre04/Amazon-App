import 'package:amazon_app/constants/global_variables.dart';
import 'package:amazon_app/features/account/screens/search_order_screen.dart';
import 'package:amazon_app/features/account/services/account_services.dart';
import 'package:amazon_app/features/account/widgets/single_product.dart';
import 'package:amazon_app/features/order_details/screens/order_details.dart';
import 'package:amazon_app/models/order.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<Order>? orders = [];
  final AccountServices accountServices = AccountServices();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    orders = await accountServices.fetchMyOrders(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Center(
            child: Text('No orders yet!',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
          )
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    child: const Text(
                      'Your Orders',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 15),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext) {
                            return SearchYourOrders();
                          }),
                        );
                      },
                      child: Text(
                        'See all',
                        style: TextStyle(
                          color: GlobalVariables.selectedNavBarColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Display Orders
              Container(
                padding: const EdgeInsets.only(left: 10, right: 0, top: 20),
                height: 170,
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: orders!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, OrderDetailsScreen.routeName,
                              arguments: orders![index]);
                        },
                        child: SingleProduct(
                          imageUrl: orders![index].products[0].images[0],
                        ),
                      );
                    }),
              )
            ],
          );
  }
}
