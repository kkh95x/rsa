import 'dart:io';
import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:rsa/user_a_home_page.dart';
import 'package:rsa/user_b_home_page.dart';

class RSAUsersPage extends StatelessWidget {
  const RSAUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child:
            Platform.isWindows ? _buildWindowsWidget() : _buildMobileWidget(),
      ),
    );
  }

  Row _buildWindowsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [UserAHomePage(), VerticalDivider(), UserBHomePage()],
    );
  }

  Widget _buildMobileWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [UserAHomePage(), Divider(), UserBHomePage()],
    );
  }
}
