import 'package:amazon_app/constants/utils.dart';
import 'package:amazon_app/features/account/screens/search_order_screen.dart';
import 'package:amazon_app/features/account/services/account_services.dart';
import 'package:amazon_app/features/account/widgets/account_button.dart';
import 'package:amazon_app/features/auth/screens/auth_screen.dart';
import 'package:amazon_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopButton extends StatefulWidget {
  const TopButton({Key? key}) : super(key: key);

  @override
  State<TopButton> createState() => _TopButtonState();
}

class _TopButtonState extends State<TopButton> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context).user;
    return Column(
      children: [
        Row(
          children: [
            AccountButton(
                text: 'Your Orders',
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext) {
                    return SearchYourOrders();
                  }));
                }),
            AccountButton(
                text: 'Turn seller',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Seller Account'),
                      content: const Text(
                        'Are you sure to change your account into seller account',
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            if (userProvider.type == "admin") {
                              showSnackBar(context, 'Already Seller Account!');
                            } else {
                              AccountServices().userToSeller(context);
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  AuthScreen.routeName, (route) => false);
                            }
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                  );
                }),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            AccountButton(
                text: 'Log Out',
                onTap: () => AccountServices().logOut(context)),
          ],
        ),
      ],
    );
  }
}
