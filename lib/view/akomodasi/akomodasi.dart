import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/custom_app_bar.dart';

class AkomodasiScreen extends StatefulWidget {
  AkomodasiScreen({Key? key}) : super(key: key);

  @override
  _AkomodasiScreenState createState() => _AkomodasiScreenState();
}

class _AkomodasiScreenState extends State<AkomodasiScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: _buildAkomodasiList(context),
        bottomNavigationBar: _buildBottomNavigation(context),
      ),
    );
  }

PreferredSizeWidget _buildAppBar(BuildContext context) {
  return CustomAppBar(
    title: Stack(
      children: [
        // Gambar sebagai background
        Container(
          height: 50.h, // Sesuaikan tinggi sesuai kebutuhan
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0.h),
            image: DecorationImage(
              image: AssetImage(ImageConstant.imgBackground), // Ganti dengan path gambar Anda
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Teks di atas gambar
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
          child: Text(
            "Akomodasi",
            style: TextStyle(
              color: Colors.white, // Warna teks putih
              fontSize: 20.h,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}


  Widget _buildAkomodasiList(BuildContext context) {
    return Column(
      children: [
        _buildAkomodasiItem(context, ImageConstant.imgHotel, "Semua Akomodasi", '/semua_akomodasi'),
        _buildAkomodasiItem(context, ImageConstant.imgHotel, "Hotel", '/akomodasi_hotel'),
        _buildAkomodasiItem(context, ImageConstant.imgHomestay, "Homestay", '/akomodasi_homestay'),
        _buildAkomodasiItem(context, ImageConstant.imgGuesthome, "Guest Home", '/akomodasi_guesthome'),
        _buildAkomodasiItem(context, ImageConstant.imgCaferesto, "Cafe dan Resto", '/akomodasi_caferesto'),
      ],
    );
  }

  Widget _buildAkomodasiItem(BuildContext context, String iconPath, String title, String route) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.h),
      child: Container(
        color: Colors.grey.shade200,
        child: ListTile(
          leading: Image.asset(iconPath, width: 32.h, height: 32.h),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18.h,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            // Navigasi ke halaman sesuai akomodasi
            Navigator.pushNamed(context, route);
          },
        ),
      ),
    );
  }


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
            child: CustomImageView(
              imagePath: ImageConstant.imgDestinasi,
              height: 32.h,
              width: 32.h,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.akomodasiScreen);
              print("Akomodasi tapped");
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
                  imagePath: ImageConstant.imgAkomodasi,
                  height: 32.h,
                  width: 32.h,
                ),
              ],
            ),
          ),
        ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.transportasiScreen);
              print("Transportasi tapped");
            },
            child: 
                CustomImageView(
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

  Widget _buildNavItem(BuildContext context, String iconPath, String label, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(iconPath, width: 32.h, height: 32.h),
          Text(
            label,
            style: TextStyle(fontSize: 12.h),
          ),
        ],
      ),
    );
  }
}
