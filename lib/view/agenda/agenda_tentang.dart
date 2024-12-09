import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../core/app_export.dart';

class AgendaTentangScreen extends StatefulWidget {
  final dynamic detail;

  const AgendaTentangScreen({Key? key, required this.detail}) : super(key: key);

  @override
  AgendaTentangScreenState createState() => AgendaTentangScreenState();
}

class AgendaTentangScreenState extends State<AgendaTentangScreen>
    with TickerProviderStateMixin {
  late TabController tabviewController;
  Map<String, dynamic> dataDetails = {};

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 2, vsync: this);

    String eventId = (widget.detail['event_id'] is String)
        ? widget.detail['event_id']
        : widget.detail['event_id'].toString();

    fetchDataDetails(eventId); // Fetch data details with event_id
  }

  // Fetching Data Details
  Future<void> fetchDataDetails(String eventId) async {
    final response = await http.get(Uri.parse(
        'http://demo.technophoria.co.id/simparta_pekalongan/api/rest_data?thisref=event&event_id=$eventId')); // Menambahkan event_id ke dalam URL

    if (response.statusCode == 200) {
      final dataList = json.decode(response.body); // Mendapatkan data sebagai list
      if (dataList.isNotEmpty) {
        final data = dataList[0]; // Ambil data pertama

        setState(() {
          dataDetails = {
            "nama_wisata": data["event_nama"] ?? "",
            "deskripsi_wisata": data["event_deskripsi"] ?? "",
            "telp": data["event_telpon"] ?? "",
            "alamat": data["event_alamat"] ?? "",
            "waktu": data["event_time"] ?? "",
            "event_file": data["event_file"] ?? "",
          };
        });
      } else {
        // Tangani kasus ketika tidak ada data yang ditemukan
        setState(() {
          dataDetails = {};
        });
      }
    } else {
      throw Exception('Failed to load data details');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              _buildImageStack(mediaQuery), // Assuming you have this method
              Expanded(
                child: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: TabBarView(
                          controller: tabviewController,
                          children: [
                            _buildDescriptionSection(mediaQuery),
                            // Removed other sections
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(Size mediaQuery) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: mediaQuery.height * 0.01),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.width * 0.05), // Padding kiri dan kanan
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Membuat konten rata kiri
                  children: [
                    SizedBox(height: mediaQuery.height * 0.01),
                    SizedBox(height: 3),
                    if (dataDetails.isNotEmpty) ...[
                      SizedBox(height: 3),
                      Text(
                        dataDetails['nama_wisata'] ?? "Nama tidak tersedia",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5),
                      Text(
                        dataDetails['deskripsi_wisata'] ??
                            "Deskripsi tidak tersedia",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Telepon:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5),
                      Text(
                        dataDetails['telp'] ?? "Telepon tidak tersedia",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Alamat:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5),
                      Text(
                        dataDetails['alamat'] ?? "Alamat tidak tersedia",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                    SizedBox(height: 16),
                      Text(
                        "Waktu:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5),
                      Text(
                        dataDetails['waktu'] ?? "Waktu tidak tersedia",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageStack(Size mediaQuery) {
    return SizedBox(
      height: mediaQuery.height * 0.2,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.center,
        children: [
          dataDetails['event_file'] != null &&
                  dataDetails['event_file'].isNotEmpty
              ? Image.network(
                  'http://demo.technophoria.co.id/simparta_pekalongan/${dataDetails['event_file']}',
                  fit: BoxFit.cover,
                  height: mediaQuery.height * 0.2,
                  width: double.maxFinite,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to default image when there's an error loading the network image
                    return Image.asset(
                      ImageConstant.imgSimpartaSampul1,
                      fit: BoxFit.cover,
                      height: mediaQuery.height * 0.2,
                      width: double.maxFinite,
                    );
                  },
                )
              : Image.asset(
                  ImageConstant.imgSimpartaSampul1,
                  fit: BoxFit.cover,
                  height: mediaQuery.height * 0.2,
                  width: double.maxFinite,
                ),
          Positioned(
            top: 8.0,
            left: 8.0,
            child: IconButton(
              icon: Icon(Icons.chevron_left, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
