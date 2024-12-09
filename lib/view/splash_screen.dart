import 'dart:async';

import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Timer untuk navigasi otomatis
    Timer(const Duration(seconds:3), () {
      Navigator.pushNamedAndRemoveUntil(
          context, '/beranda_screen', (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.maxFinite,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background Image
              CustomImageView(
                imagePath: ImageConstant.imgBackground,
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                fit: BoxFit.cover, // Menutupi layar penuh
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.55,
                    width: double.maxFinite,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgSplash1,
                          height: 326.h,
                          width: 288.h,
                          // radius: BorderRadius.circular(144.h),
                          alignment: Alignment.centerLeft,
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgSplash2,
                          height: 174.h,
                          width: 146.h,
                          // radius: BorderRadius.circular(72.h),
                          alignment: Alignment.centerRight,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 22.h),
                  _buildInformationSection(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInformationSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 10.h, right: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      child: Column(
        children: [
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.only(left: 14.h),
            child: Column(
              children: [
                Text(
                  "Temukan Destinasi, Budaya, dan Informasi terlengkap di satu aplikasi.",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                  style: CustomTextStyles.titleMediumWhiteA700,
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onTapMulai(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.berandaScreen);
  }
}
