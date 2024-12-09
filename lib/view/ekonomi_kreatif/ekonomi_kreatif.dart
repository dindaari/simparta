import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/custom_app_bar.dart';

class EkonomiKreatifScreen extends StatefulWidget {
  EkonomiKreatifScreen({Key? key, required detail}) : super(key: key);

  @override
  _EkonomiKreatifScreenState createState() => _EkonomiKreatifScreenState();
}

class _EkonomiKreatifScreenState extends State<EkonomiKreatifScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: _buildEkonomiKreatifList(context),
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
                image: AssetImage(ImageConstant.imgBackground),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Teks di atas gambar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
            child: Text(
              "Ekonomi Kreatif",
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

  Widget _buildEkonomiKreatifList(BuildContext context) {
    return ListView(
      children: [
        _buildEkonomiKreatifItem(
            context, "Semua Ekonomi dan Kreatif", '/semua_ekonomi_kreatif'),
        _buildEkonomiKreatifItem(context, "Arsitektur", '/arsitektur'),
        _buildEkonomiKreatifItem(context, "Fashion", '/fashion'),
        _buildEkonomiKreatifItem(context, "Penerbitan", '/penerbitan'),
        _buildEkonomiKreatifItem(context, "Kriya", '/kriya'),
        _buildEkonomiKreatifItem(context, "Musik", '/musik'),
        _buildEkonomiKreatifItem(
            context, "Seni Pertunjukan", '/seni_pertunjukan'),
        _buildEkonomiKreatifItem(context, "Aplikasi Dan Pengembang Permainan",
            '/aplikasi_pengembangan_permainan'),
        _buildEkonomiKreatifItem(context, "Desain Produk", '/desain_produk'),
        _buildEkonomiKreatifItem(
            context, "Film, Animasi, Dan Video", '/film_animasi_video'),
        _buildEkonomiKreatifItem(context, "Fotografi", '/fotografi'),
        _buildEkonomiKreatifItem(context, "Kuliner", '/kuliner'),
        _buildEkonomiKreatifItem(context, "Seni Rupa", '/seni_rupa'),
        _buildEkonomiKreatifItem(
            context, "Radio Dan Televisi", '/radio_televisi'),
      ],
    );
  }

  Widget _buildEkonomiKreatifItem(BuildContext context, String title,
      [String? routeName]) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.h),
      child: Container(
        color: Colors.grey.shade200,
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18.h,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            if (routeName != null) {
              Navigator.pushNamed(
                  context, routeName); // Navigasi ke rute yang diberikan
            } else {
              // Jika tidak ada rute, tambahkan aksi atau keluarkan log
              print("No route defined for $title");
            }
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
                    imagePath: ImageConstant.imgEkonomiKreatif,
                    height: 32.h,
                    width: 32.h,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
