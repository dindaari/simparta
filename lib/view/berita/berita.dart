import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_simparta/core/app_export.dart';
import 'package:http/http.dart' as http;

class BeritaScreen extends StatefulWidget {
  const BeritaScreen({Key? key}) : super(key: key);

  @override
  State<BeritaScreen> createState() => _BeritaScreenState();
}

class _BeritaScreenState extends State<BeritaScreen> {
    List<dynamic> dataBerita = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchBeritaData();
  }

  Future<void> fetchBeritaData() async {
    final url = Uri.parse(
        'http://demo.technophoria.co.id/simparta_pekalongan/api/rest_data?thisref=berita');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        setState(() {
          dataBerita = data; // Mengambil semua data berita
          isLoading = false;
        });
      } else {
        throw Exception(
            'Failed to load data, status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
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
                ? Center(child: Text('Failed to load data: $errorMessage'))
                : _buildContent(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Stack(
        children: [
          Container(
            height: 50.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Semua Berita",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 20.h,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(width: 140.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
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
          crossAxisCount: 1, 
          mainAxisSpacing: 20.h,
          crossAxisSpacing: 20.h,
        ),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: dataBerita.length,
        itemBuilder: (context, index) {
          final item = dataBerita[index];
          return _buildGridItem(item);
        },
      ),
    );
  }

Widget _buildGridItem(dynamic item) {
    return GestureDetector(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Membatasi tinggi kolom sesuai dengan konten
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            item['event_file_small'] != null
                ? Image.network(
                    'http://demo.technophoria.co.id/simparta_pekalongan/${item['event_file_small']}',
                    fit: BoxFit.cover,
                    height: 88.h, // Mengurangi tinggi gambar
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        ImageConstant.imgSimpartaSampul1,
                        fit: BoxFit.cover,
                        height: 88.h, // Sesuaikan tinggi fallback image juga
                        width: double.infinity,
                      );
                    },
                  )
                : Image.asset(
                    ImageConstant.imgSimpartaSampul1,
                    fit: BoxFit.cover,
                    height: 88.h, // Sesuaikan tinggi image default
                    width: double.infinity,
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['berita_nama'] ?? 'Tidak ada nama',
                    maxLines: 2,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 11.h, // Mengurangi ukuran teks
                    ),
                  ),
                  SizedBox(height: 4.h), // Sesuaikan jarak antar teks
                  Text(
                    item['berita_deskripsi'] ?? 'Tidak ada deskripsi',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9.h, // Mengurangi ukuran deskripsi
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
}