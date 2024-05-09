import 'package:flutter/material.dart';
import 'package:rsa/pdf_page.dart';
import 'package:rsa/rsa_users_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        "assets/rsa.png",
                        width: 400,
                      ))
                  .animate()
                  .fade(
                      begin: 0,
                      duration: const Duration(milliseconds: 200),
                      end: 1)
                  .slideY(
                      begin: -.2,
                      duration: const Duration(milliseconds: 200),
                      end: 0),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const RSAUsersPage(),
                        ));
                      },
                      child: const Text("Get Started"))
                  .animate()
                  .fade(
                      begin: 0,
                      duration: const Duration(milliseconds: 200),
                      delay: const Duration(milliseconds: 100),
                      end: 1)
                  .slideY(
                      duration: const Duration(milliseconds: 200),
                      delay: const Duration(milliseconds: 100),
                      begin: -.2,
                      end: 0),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const PdfPage(),
                        ));
                      },
                      child: const Text("What is RSA Algorithm"))
                  .animate()
                  .fade(
                      begin: 0,
                      duration: const Duration(milliseconds: 200),
                      delay: const Duration(milliseconds: 150),
                      end: 1)
                  .slideY(
                      duration: const Duration(milliseconds: 200),
                      delay: const Duration(milliseconds: 150),
                      begin: -.2,
                      end: 0),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  launchUrl(Uri.parse("https://www.instagram.com/kkh95x/"));
                },
                child: Text(
                  "by Abdulkarim Alkhatib",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic, color: Colors.grey),
                )
                    .animate()
                    .fade(
                        begin: 0,
                        duration: const Duration(milliseconds: 200),
                        delay: const Duration(milliseconds: 200),
                        end: 1)
                    .slideY(
                        duration: const Duration(milliseconds: 200),
                        delay: const Duration(milliseconds: 200),
                        begin: -.2,
                        end: 0),
              ),
              const SizedBox(
                height: 10,
              ),
              ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        "assets/logo.png",
                        height: 100,
                      ))
                  .animate()
                  .fade(
                      begin: 0,
                       duration: const Duration(milliseconds: 200),
                      delay: const Duration(milliseconds: 250),
                      end: 1)
                  .slideY(
                    duration: const Duration(milliseconds: 200),
                      delay: const Duration(milliseconds: 250),
                      begin: -.2,
                      end: 0)
            ],
          ),
        ),
      ),
    );
  }
}
