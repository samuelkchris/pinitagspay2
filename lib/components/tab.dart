import 'package:flutter/material.dart';

import 'customcard.dart';

class TabBarPage extends StatelessWidget {
  const TabBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      height: size.height * 0.53,
      child: const CustomGridView(),
    );
  }
}
