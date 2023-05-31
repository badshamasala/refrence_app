import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class GhostScreen extends StatelessWidget {
  final String image;

  const GhostScreen({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Lottie.asset(
        image,
        width: double.infinity,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
