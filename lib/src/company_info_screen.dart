import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // For social media icons
import 'package:url_launcher/url_launcher.dart'; // For launching URLs

class CompanyInfoScreen extends StatelessWidget {
  const CompanyInfoScreen({super.key});

  // Method to launch URLs
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Company Information"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company Info Section
              const Text(
                "PushStartHub",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "PushStartHub is a tech-driven innovation company specializing in "
                "creating solutions that empower individuals and businesses to "
                "achieve their full potential in the digital world.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "Founded: 2020",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                "Founder: Ronak Jain (Co-Founder)",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              // Social Media Links for Company
              const Text(
                "Connect with Us on Social Media:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Social Media Buttons with Icons
              Row(
                children: [
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.twitter,
                        color: Colors.blue),
                    tooltip: 'Twitter',
                    onPressed: () => _launchURL("https://x.com/push_startup"),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.instagram,
                        color: Colors.purple),
                    tooltip: 'Instagram',
                    onPressed: () =>
                        _launchURL("https://www.instagram.com/push.startup/"),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.whatsapp,
                        color: Colors.green),
                    tooltip: 'WhatsApp',
                    onPressed: () => _launchURL(
                        "https://api.whatsapp.com/send/?phone=7023941072&text&type=phone_number&app_absent=0"),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Developer Info Section
              const Text(
                "Developer Information",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Developer: Ronak Jain",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Role: Flutter Developer & AI Enthusiast",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                "Skills: Flutter, Dart, AI/ML Integration, Web Development",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "Connect with Developer:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Social Media Buttons for Developer
              Row(
                children: [
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.linkedin,
                        color: Colors.blue),
                    tooltip: 'LinkedIn',
                    onPressed: () => _launchURL(
                        "https://www.linkedin.com/in/ronak-jain-b312b4258/"),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.github,
                        color: Colors.black),
                    tooltip: 'GitHub',
                    onPressed: () => _launchURL(
                        "https://github.com/RonakWithCode?tab=repositories"),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.instagram,
                        color: Colors.purple),
                    tooltip: 'Instagram',
                    onPressed: () =>
                        _launchURL("https://www.instagram.com/justtronak/"),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Visit Company Website Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _launchURL("https://pushstarthub.vercel.app/");
                  },
                  icon: const Icon(Icons.language),
                  label: const Text("Visit Our Website"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
