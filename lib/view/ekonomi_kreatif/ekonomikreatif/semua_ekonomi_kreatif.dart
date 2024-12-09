import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_simparta/core/app_export.dart';
import 'package:flutter_simparta/view/ekonomi_kreatif/ekonomi_tentang/ekonomi_tentang_screen.dart';
import 'package:http/http.dart' as http;

class SemuaEkonomiKreatif extends StatefulWidget {
  const SemuaEkonomiKreatif({Key? key}) : super(key: key);

  @override
  State<SemuaEkonomiKreatif> createState() => _SemuaEkonomiKreatifState();
}

class _SemuaEkonomiKreatifState extends State<SemuaEkonomiKreatif> {
  List<dynamic> dataEkonomiKreatif = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchEkonomiKreatifData();
  }

  Future<void> fetchEkonomiKreatifData() async {
    final url = Uri.parse(
        'http://demo.technophoria.co.id/simparta_pekalongan/api/rest_data?thisref=obyek');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        final List<dynamic> ekonomiKreatifData = data.where((item) {
          return item['obyek_jenis'] == 'ekonomi_kreatif'; // Ganti dengan filter yang sesuai
        }).toList();

        setState(() {
          dataEkonomiKreatif = ekonomiKreatifData;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data, status code: ${response.statusCode}');
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
                    "Semua Ekonomi Kreatif",
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
        itemCount: dataEkonomiKreatif.length,
        itemBuilder: (context, index) {
          final item = dataEkonomiKreatif[index];
          return _buildGridItem(item);
        },
      ),
    );
  }

  Widget _buildGridItem(dynamic item) {
    return GestureDetector(
      onTap: () {
        if (item != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EkonomiTentangScreen(detail: item),
            ),
          );
        } else {
          // Tampilkan pesan error jika item null
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Item tidak valid!')),
          );
        }
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
}
