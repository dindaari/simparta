import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';

class DestinasiScreen extends StatelessWidget {
  const DestinasiScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              height: 688.h,
              alignment: Alignment.topCenter,
              child: Stack(
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgBackground,
                    height: 642.h,
                    width: double.maxFinite,
                  ),
                  _buildDestinationGrid(context),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNavigation(context),
      ),
    );
  }

  /// Builds the AppBar section
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: AppbarTitle(
        text: "Destinasi",
        margin: EdgeInsets.only(left: 15.h),
      ),
    );
  }

  Widget _buildDestinationGrid(BuildContext context) {
    List<String> imagePaths = [
      ImageConstant.imgSemuaDestinasi,
      ImageConstant.imgWisataAlam,
      ImageConstant.imgWisataBahari,
      ImageConstant.imgWisataBelanja,
      ImageConstant.imgWisataBuatan,
      ImageConstant.imgWisataBudaya,
      ImageConstant.imgWisataEdukasi,
      ImageConstant.imgWisataKuliner,
      ImageConstant.imgWisataMinatKhusus,
      ImageConstant.imgWisataReligi,
      ImageConstant.imgWisataSejarah,
      ImageConstant.imgKampungWisata,
    ];

    List<String> titles = [
      "Semua Destinasi",
      "Wisata Alam",
      "Wisata Bahari",
      "Wisata Belanja",
      "Wisata Buatan",
      "Wisata Budaya",
      "Wisata Edukasi",
      "Wisata Kuliner",
      "Wisata Minat Khusus",
      "Wisata Religi",
      "Wisata Sejarah",
      "Kampung Wisata",
    ];

    return Padding(
      padding: EdgeInsets.only(left: 10.h, top: 26.h, right: 12.h),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 120.h, // Adjusted for text height and spacing
          crossAxisCount: 4,
          mainAxisSpacing: 28.h,
          crossAxisSpacing: 28.h,
        ),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          return DestinationgridItemWidget(
            imagePath: imagePaths[index],
            title: titles[index],
            imageHeight: 50.h, // Set image height
            imageWidth: 50.h, // Set image width
            textColor: Colors.white, // Set text color
            onTap: () {
              // Navigasi ke layar yang berbeda berdasarkan index
              switch (index) {
                case 0:
                  Navigator.pushNamed(
                      context, AppRoutes.destinasiSemuaScreen);
                  break;
                case 1:
                  Navigator.pushNamed(
                      context, AppRoutes.destinasiWisataAlamScreen);
                  break;
                case 2:
                  Navigator.pushNamed(context, AppRoutes.destinasiWisataBahariScreen);
                  break;
                case 3:
                  Navigator.pushNamed(context, AppRoutes.destinasiWisataBelanjaScreen);
                  break;
                case 4:
                  Navigator.pushNamed(context, AppRoutes.destinasiWisataBuatanScreen);
                  break;
                case 5:
                  Navigator.pushNamed(context, AppRoutes.destinasiWisataBudayaScreen);
                  break;
                case 6:
                  Navigator.pushNamed(context, AppRoutes.destinasiWisataEdukasiScreen);
                  break;
                case 7:
                  Navigator.pushNamed(context, AppRoutes.destinasiWisataKulinerScreen);
                  break;
                case 8:
                  Navigator.pushNamed(context, AppRoutes.destinasiWisataMinatKhusus);
                  break;
                case 9:
                  Navigator.pushNamed(context, AppRoutes.destinasiWisataRelijiScreen);
                  break;
                case 10:
                  Navigator.pushNamed(context, AppRoutes.destinasiWisataSejarahScreen);
                  break;
                case 11:
                  Navigator.pushNamed(context, AppRoutes.destinasiKampungWisataScreen);
                  break;
                default:
                  print("Unknown destination");
              }
            },
          );
        },
      ),
    );
  }

  /// Bottom Navigation Bar Widget
  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      height: 32.h,
      margin: EdgeInsets.only(left: 42.h, right: 42.h, bottom: 15.h, top: 15.h),
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.berandaScreen),
            child: SizedBox(
              height: 32.h,
              width: 32.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgHome,
                    height: 32.h,
                    width: 32.h,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.destinasiScreen);
              print("Destinasi tapped");
            },
            child: SizedBox(
              height: 32.h,
              width: 32.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 20.h,
                      width: 22.h,
                      decoration: BoxDecoration(
                        color: appTheme.cyan700,
                      ),
                    ),
                  ),
                  CustomImageView(
                    imagePath: ImageConstant.imgDestinasi,
                    height: 32.h,
                    width: 32.h,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.akomodasiScreen);
              print("Akomodasi tapped");
            },
            child: CustomImageView(
              imagePath: ImageConstant.imgAkomodasi,
              height: 32.h,
              width: 32.h,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.transportasiScreen);
              print("Transportasi tapped");
            },
            child: CustomImageView(
              imagePath: ImageConstant.imgTransportasi,
              height: 32.h,
              width: 32.h,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.ekonomiKreatifScreen);
              print("Ekonomi Kreatif tapped");
            },
            child: CustomImageView(
              imagePath: ImageConstant.imgEkonomiKreatif,
              height: 32.h,
              width: 32.h,
            ),
          ),
        ],
      ),
    );
  }
}

/// Destination Grid Item Widget
class DestinationgridItemWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final double imageHeight;
  final double imageWidth;
  final Color textColor;
  final VoidCallback onTap;

  const DestinationgridItemWidget({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.onTap,
    this.imageHeight = 80.0, // Default height if not specified
    this.imageWidth = 80.0, // Default width if not specified
    this.textColor = Colors.white, // Default text color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            imagePath,
            height: imageHeight,
            width: imageWidth,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 5.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.h, // Adjust font size as needed
              fontWeight: FontWeight.w500,
              color: textColor, // Use the passed color
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
