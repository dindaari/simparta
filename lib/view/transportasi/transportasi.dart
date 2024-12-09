import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_simparta/core/app_export.dart';
import 'package:http/http.dart' as http;
import '../../widgets/app_bar/custom_app_bar.dart';
import 'transportasi_tentang.dart';

class TransportasiScreen extends StatefulWidget {
  const TransportasiScreen({Key? key}) : super(key: key);

  @override
  State<TransportasiScreen> createState() => _TransportasiScreenState();
}

class _TransportasiScreenState extends State<TransportasiScreen> {
  List<dynamic> dataTransportasi = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchTransportasiData();
  }

  // Fungsi untuk mengambil data dari API
  Future<void> fetchTransportasiData() async {
    final url = Uri.parse(
        'http://demo.technophoria.co.id/simparta_pekalongan/api/rest_data?thisref=obyek');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Filter data dengan obyek_jenis "Transportasi"
        final List<dynamic> transportasiData = data.where((item) {
          return item['obyek_jenis'] == 'tour_and_travel';
        }).toList();

        setState(() {
          dataTransportasi = transportasiData;
          isLoading = false;
        });
      } else {
        throw Exception(
            'Failed to load data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : hasError
                ? Center(child: Text('Failed to load data'))
                : _buildContent(),
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
            "Transportasi",
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

  Widget _buildContent() {
    return Expanded(
      child: ListView(
        children: [
          SizedBox(height: 10.h),
          _buildGridSection(),
        ],
      ),
    );
  }

  Widget _buildGridSection() {
    return Padding(
      padding: EdgeInsets.only(left: 10.h, right: 12.h),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 179.h,
          crossAxisCount: 2,
          mainAxisSpacing: 20.h,
          crossAxisSpacing: 20.h,
        ),
        shrinkWrap: true,
        physics: ScrollPhysics(), // Agar grid dapat di-scroll
        itemCount: dataTransportasi.length,
        itemBuilder: (context, index) {
          final item = dataTransportasi[index];
          return _buildGridItem(item);
        },
      ),
    );
  }

  Widget _buildGridItem(dynamic item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransportasiTentangScreen(
                detail: item), // Navigasi ke detail screen
          ),
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            item['obyek_file_small'] != null
                ? Image.network(
                    'http://demo.technophoria.co.id/simparta_pekalongan/${item['obyek_file_small']}',
                    fit: BoxFit.cover,
                    height: 100.h,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        ImageConstant.imgSimpartaSampul1,
                        fit: BoxFit.cover,
                        height: 100.h,
                        width: double.infinity,
                      );
                    },
                  )
                : Image.asset(
                    ImageConstant.imgSimpartaSampul1,
                    fit: BoxFit.cover,
                    height: 100.h,
                    width: double.infinity,
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['obyek_nama'] ?? 'Tidak ada nama',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.h,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    item['obyek_keterangan'] ?? 'Tidak ada keterangan',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.h,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
                    imagePath: ImageConstant.imgTransportasi,
                    height: 32.h,
                    width: 32.h,
                  ),
                ],
              ),
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
