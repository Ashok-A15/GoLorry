import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dashboard_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key}); // no const for stateful widgets

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController password = TextEditingController();

  final auth = FirebaseAuth.instance;

  Future<void> signup() async {
    if (name.text.isEmpty ||
        email.text.isEmpty ||
        phone.text.isEmpty ||
        password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields required")),
      );
      return;
    }

    try {
      // 1️⃣ Create User in Firebase Auth
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      final uid = userCredential.user!.uid;

      // 2️⃣ Save Owner profile in Firestore
      await FirebaseFirestore.instance.collection("owners").doc(uid).set({
        "name": name.text.trim(),
        "email": email.text.trim(),
        "phone": phone.text.trim(),
        "createdAt": DateTime.now(),
      });

      // 3️⃣ Navigate to Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    } on FirebaseAuthException catch (e) {
      String msg = "Signup failed";
      if (e.code == 'email-already-in-use') msg = "Email already used";
      if (e.code == 'invalid-email') msg = "Invalid email format";
      if (e.code == 'weak-password') msg = "Password is too weak";

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Owner Signup")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: "Full Name"),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: email,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: phone,
              decoration: const InputDecoration(labelText: "Phone"),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: signup,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text("Signup", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
