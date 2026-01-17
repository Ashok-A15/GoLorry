import 'package:flutter/material.dart';
import 'email_login_page.dart';
import 'phone_login_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {

  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Laari Login"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TabBar(
            controller: controller,
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: "Email Login"),
              Tab(text: "Phone Login"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: controller,
              children: const [
                EmailLoginPage(),
                PhoneLoginPage(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
