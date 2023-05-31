import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupportController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // late TabController tabController;

  TextEditingController concernCatergoryTextController =
      TextEditingController();
  TextEditingController concernIssueTextController = TextEditingController();
  TextEditingController concernDescriptionController = TextEditingController();
  TextEditingController feedbackCategoryTextController =
      TextEditingController();
  TextEditingController feedbackDescriptionController = TextEditingController();

  String selectedType = "Concern";
  // List<String> tabs = ["Concern", "Feedback"];
  List<String> listCategories = [
    'App/Tech',
    'Content',
    'Account',
    'Healing Program',
    'Payment',
    'Others'
  ];
  Map<String, List<String>> listIssuesFromCategories = {
    "App/Tech": [
      "App slow",
      "App not working",
      "App crashing",
      "App eating lot of battery",
      "Data consumption",
      "Content player issues",
      "Others",
    ],
    "Content": [
      "Content recommendation issues",
      "Not enough content",
      "Others",
    ],
    "Healing Program": [
      "Enquiries",
      "Renewal",
      "Health score",
      "Personalised program",
      "Doctor consult",
      "Yoga Therapy",
      "Charges",
      "Others",
    ],
    "Account": [
      "Profile related",
      "Login and security",
      "Password related",
    ],
    "Payment": [
      "Payment failure",
      "Payment not reflecting",
      "Payment debited multiple times",
      "My payment method not found",
      "Delete my payment details",
      "Other",
    ]
  };

  Future<void> sendWhatsappText(String number) async {
    String text = Uri.encodeFull(
        "Category: ${concernCatergoryTextController.text.trim()}\nIssue: ${concernIssueTextController.text.trim()}\nDescription: ${concernDescriptionController.text.trim()}");

    String url = "https://wa.me/$number?text=$text";
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}
