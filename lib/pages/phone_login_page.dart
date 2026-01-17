import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dashboard_page.dart';  // <-- ⭐ Add This

class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({super.key});

  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  String verificationId = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: phoneController,
            decoration: const InputDecoration(
              labelText: "Phone Number",
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              await _auth.verifyPhoneNumber(
                phoneNumber: "+91${phoneController.text}",
                verificationCompleted: (credential) async {
                  await _auth.signInWithCredential(credential);

                  // ⭐ Go to dashboard after auto verify
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DashboardPage(),
                    ),
                  );
                },
                verificationFailed: (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.message ?? "Error")),
                  );
                },
                codeSent: (id, _) {
                  verificationId = id;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("OTP Sent")),
                  );
                },
                codeAutoRetrievalTimeout: (_) {},
              );
            },
            child: const Text("Send OTP"),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: otpController,
            decoration: const InputDecoration(
              labelText: "Enter OTP",
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              try {
                PhoneAuthCredential cred = PhoneAuthProvider.credential(
                  verificationId: verificationId,
                  smsCode: otpController.text,
                );

                await _auth.signInWithCredential(cred);

                // ⭐ Navigate here after OTP success
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DashboardPage(),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: $e")),
                );
              }
            },
            child: const Text("Verify OTP"),
          ),
        ],
      ),
    );
  }
}
