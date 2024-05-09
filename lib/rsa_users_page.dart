import 'package:flutter/material.dart';
import 'package:rsa/user_a_home_page.dart';
import 'package:rsa/user_b_home_page.dart';

class RSAUsersPage extends StatelessWidget {
  const RSAUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return    Scaffold(
      appBar: AppBar(),
        body:const SingleChildScrollView(
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              UserAHomePage(),
              VerticalDivider(),
              UserBHomePage()
            ],
          ),
        ),
      );
  }
}