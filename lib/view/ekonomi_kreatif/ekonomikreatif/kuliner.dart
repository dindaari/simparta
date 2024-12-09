import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_simparta/core/app_export.dart';
import 'package:http/http.dart' as http;

class KulinerScreen extends StatefulWidget {
  const KulinerScreen({Key? key}) : super(key: key);

  @override
  State<KulinerScreen> createState() => _KulinerScreenState();
}

class _KulinerScreenState extends State<KulinerScreen> {
  List<dynamic> dataKuliner = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchKulinerData();
  }

  Future<void> fetchKulinerData() async {
    final url = Uri.parse(
        'http://demo.technophoria.co.id/simparta_pekalongan/api/rest_data?thisref=obyek&kategori_sub_id=36');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        final List<dynamic> kulinerData = data.where((item) {
          return item['obyek_id'] != null; // Pastikan ada 'obyek_id'
        }).toList();

        setState(() {
          dataKuliner = kulinerData;
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
                    "Kuliner",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 20.h,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(width: 130.h),
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
          crossAxisCount: 2,
          mainAxisSpacing: 20.h,
          crossAxisSpacing: 20.h,
        ),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: dataKuliner.length,
        itemBuilder: (context, index) {
          final item = dataKuliner[index];
          return _buildGridItem(item);
        },
      ),
    );
  }

  Widget _buildGridItem(dynamic item) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke detail screen bisa ditambahkan di sini
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            item['foto_file'] != null
                ? Image.network(
                    'http://demo.technophoria.co.id/simparta_pekalongan/${item['foto_file']}',
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
}