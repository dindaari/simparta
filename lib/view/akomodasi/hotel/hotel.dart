import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_simparta/core/app_export.dart';
import 'package:http/http.dart' as http;

class HotelScreen extends StatefulWidget {
  const HotelScreen({Key? key}) : super(key: key);

  @override
  State<HotelScreen> createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> {
  List<dynamic> dataHotel = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  String selectedStarFilter = 'Semua'; // Filter Bintang

  @override
  void initState() {
    super.initState();
    fetchHotelData();
  }

  Future<void> fetchHotelData() async {
    final url = Uri.parse(
        'http://demo.technophoria.co.id/simparta_pekalongan/api/rest_data?thisref=obyek&kategori_sub_id=12');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        final List<dynamic> hotelData = data.where((item) {
          return item['obyek_id'] != null; // Pastikan ada 'obyek_id'
        }).toList();

        setState(() {
          dataHotel = hotelData;
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

  List<dynamic> getFilteredHotels() {
    if (selectedStarFilter == 'Semua') {
      return dataHotel;
    }
    return dataHotel.where((hotel) {
      return hotel['obyek_keterangan'] == selectedStarFilter;
    }).toList();
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
                    "Hotel",
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
          _buildFilterDropdown(),
          SizedBox(height: 10.h),
          _buildGridSection(),
        ],
      ),
    );
  }

  // Dropdown untuk filter bintang
  Widget _buildFilterDropdown() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      child: SizedBox(
        width: double.infinity, // Memastikan dropdown memanjang ke kanan kiri
        child: DropdownButton<String>(
          value: selectedStarFilter,
          isExpanded: true, // Membuat dropdown memenuhi lebar yang tersedia
          items: [
            DropdownMenuItem(value: 'Semua', child: Text('Semua Bintang')),
            DropdownMenuItem(value: 'Bintang 1', child: Text('Bintang 1')),
            DropdownMenuItem(value: 'Bintang 2', child: Text('Bintang 2')),
            DropdownMenuItem(value: 'Bintang 3', child: Text('Bintang 3')),
            DropdownMenuItem(value: 'Bintang 4', child: Text('Bintang 4')),
            DropdownMenuItem(value: 'Bintang 5', child: Text('Bintang 5')),
          ],
          onChanged: (value) {
            setState(() {
              selectedStarFilter = value!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildGridSection() {
    List<dynamic> filteredHotels = getFilteredHotels();

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
        itemCount: filteredHotels.length,
        itemBuilder: (context, index) {
          final item = filteredHotels[index];
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
