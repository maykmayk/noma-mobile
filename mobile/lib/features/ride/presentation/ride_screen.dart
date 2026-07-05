import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RideScreen extends StatelessWidget {
  const RideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('ride.title'.tr()),
      ),
      body: Center(
        child: Text('ride.body'.tr()),
      ),
    );
  }
}
