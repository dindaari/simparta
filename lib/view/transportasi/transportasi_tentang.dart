import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/image_constant.dart';

class TransportasiTentangScreen extends StatefulWidget {
  final dynamic detail;

  const TransportasiTentangScreen({Key? key, required this.detail})
      : super(key: key);

  @override
  TransportasiTentangScreenState createState() => TransportasiTentangScreenState();
}

class TransportasiTentangScreenState extends State<TransportasiTentangScreen>
    with TickerProviderStateMixin {
  late TabController tabviewController;
  Completer<GoogleMapController> googleMapController = Completer();
  List<String> _photos = [];
  List<dynamic> _harga = [];
  List<dynamic> _fasilitas = [];
  Map<String, dynamic> dataDetails = {};

  String _noDataMessage = 'Tidak ada harga yang tercantum';

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 4, vsync: this);
    fetchPhotoData();
    fetchHargaData();
    fetchFasilitasData();

    String obyekJenis =
        widget.detail['obyek_jenis'] ?? ''; 
    String obyekId = (widget.detail['obyek_id'] is String)
        ? widget.detail['obyek_id']
        : widget.detail['obyek_id'].toString();
    fetchDataDetails(obyekJenis, obyekId); 
  }

  Future<void> fetchPhotoData() async {
    String obyekId = (widget.detail['obyek_id'] is String)
        ? widget.detail['obyek_id']
        : widget.detail['obyek_id'].toString();

    final String apiUrl =
        'http://demo.technophoria.co.id/simparta_pekalongan/api/rest_data?thisref=obyek&kategori_id=2&obyek_id=$obyekId';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _photos = data.map<String>((item) {
            return item["obyek_file"] ?? ImageConstant.imgSimpartaSampul1;
          }).toList();
        });
      } else {
        print("Failed to load photo data. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching photo data: $error");
    }
  }

  Future<void> fetchHargaData() async {
    String obyekId = (widget.detail['obyek_id'] is String)
        ? widget.detail['obyek_id']
        : widget.detail['obyek_id'].toString();

    print("Fetching data for obyek_id: $obyekId");

    final String apiUrl =
        'http://demo.technophoria.co.id/simparta_pekalongan/api/rest_data?thisref=harga';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print("Received data: $data");

        List<Map<String, String>> hargaList = [];

        for (var item in data) {
          if (item is Map<String, dynamic> && item['obyek_id'] == obyekId) {
            hargaList.add({
              'harga_nama': item['harga_nama']?.toString() ?? '',
              'harga_keterangan': item['harga_keterangan']?.toString() ?? '',
              'harga_rupiah': item['harga_rupiah']?.toString() ?? '',
            });
          }
        }

        if (hargaList.isEmpty) {
          print("No prices found for obyek_id: $obyekId");
          setState(() {
            _harga = [];
            _noDataMessage = "Tidak ada harga yang tercantum";
          });
        } else {
          print("Prices found for obyek_id: $obyekId: $hargaList");
          setState(() {
            _harga = hargaList;
            _noDataMessage = "";
          });
        }
      } else {
        print("Failed to load harga data. Status code: ${response.statusCode}");
        setState(() {
          _noDataMessage = "Terjadi kesalahan dalam memuat data";
        });
      }
    } catch (error) {
      print("Error fetching harga data: $error");
      setState(() {
        _noDataMessage = "Terjadi kesalahan dalam memuat data";
      });
    }
  }

  Future<void> fetchFasilitasData() async {
    String obyekId = (widget.detail['obyek_id'] is String) 
        ? widget.detail['obyek_id'] 
        : widget.detail['obyek_id'].toString();
    const String apiUrl = 'http://demo.technophoria.co.id/simparta_pekalongan/api/rest_data?thisref=fasilitas';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<dynamic> filteredData = data
            .where((item) => item['obyek_jenis'] == 'transportasi' && item['obyek_id'] == obyekId)
            .toList();

        setState(() {
          _fasilitas = filteredData.map((item) => item['nama_fasilitas']).toList();
        });
      } else {
        print("Failed to load fasilitas data. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching fasilitas data: $error");
    }
  }
  
  Future<void> fetchDataDetails(String obyekJenis, String obyekId) async {
    final response = await http.get(Uri.parse(
        'http://demo.technophoria.co.id/simparta_pekalongan/api/rest_data?thisref=obyek&kategori_id=2&obyek_id=$obyekId'));

    if (response.statusCode == 200) {
      final data =
          json.decode(response.body)[0]; 

      setState(() {
        dataDetails = {
          "nama_transportasi": data["obyek_nama"] ?? "",
          "deskripsi_transportasi": data["obyek_deskripsi"] ?? "",
          "telp": data["obyek_telpon"] ?? "",
          "email": data["obyek_email"] ?? "",
          "website": data["obyek_website"] ?? "",
          "alamat": data["obyek_alamat"] ?? "",
        };
      });
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
              _buildImageStack(mediaQuery),
              Expanded(
                child: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(height: mediaQuery.height * 0.02),
                      _buildTabview(context),
                      Expanded(
                        child: TabBarView(
                          controller: tabviewController,
                          children: [
                            _buildDescriptionSection(mediaQuery),
                            _buildPhotoGrid(),
                            _buildHargaSection(),
                            _buildFasilitasSection(),
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
                padding: EdgeInsets.symmetric(horizontal: mediaQuery.width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: mediaQuery.height * 0.01),
                    SizedBox(height: 3),
                    if (dataDetails.isNotEmpty) ...[
                      SizedBox(height: 3),
                      Text(
                        dataDetails['nama_transportasi'] ?? "Nama tidak tersedia",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5),
                      Text(
                        dataDetails['deskripsi_transportasi'] ?? "Deskripsi tidak tersedia",
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
                        "Email:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5),
                      Text(
                        dataDetails['email'] ?? "Email tidak tersedia",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Website:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5),
                      Text(
                        dataDetails['website'] ?? "Website tidak tersedia",
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGrid() {
    if (_photos.isEmpty) {
      return Center(
          child: CircularProgressIndicator()); // Jika foto masih diambil
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Jumlah kolom dalam grid
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: _photos.length,
        itemBuilder: (context, index) {
          String? photoUrl = _photos.isNotEmpty ? _photos[index] : null;
          return photoUrl != null && photoUrl.isNotEmpty
              ? Image.network(
                  'http://demo.technophoria.co.id/simparta_pekalongan/$photoUrl',
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    }
                  },
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return Image.asset(
                      ImageConstant.imgSimpartaSampul1,
                      fit: BoxFit.cover,
                    );
                  },
                )
              : Image.asset(
                  ImageConstant.imgSimpartaSampul1,
                  fit: BoxFit.cover,
                );
        },
      ),
    );
  }

  Widget _buildHargaSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Text(
          //   'Harga',
          //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          // ),
          if (_harga.isEmpty)
            Text(_noDataMessage)
          else
            Expanded(
              child: ListView.builder(
                itemCount: _harga.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_harga[index]['harga_nama']),
                    subtitle: Text(
                      '${_harga[index]['harga_rupiah']} - ${_harga[index]['harga_keterangan']}',
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFasilitasSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Text(
          //   'Fasilitas',
          //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          // ),
          if (_fasilitas.isEmpty)
            Text('Tidak ada fasilitas yang tercantum')
          else
            Expanded(
              child: ListView.builder(
                itemCount: _fasilitas.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_fasilitas[index] ?? 'Fasilitas tidak tersedia'),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageStack(Size mediaQuery) {
    return Stack(
      children: [
        Container(
          height: mediaQuery.height * 0.3,
          width: double.infinity,
          child: Image.network(
            _photos.isNotEmpty
                ? _photos[0]
                : ImageConstant.imgSimpartaSampul1,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          height: mediaQuery.height * 0.3,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black54,
                Colors.transparent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Text(
            '',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabview(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TabBar(
        controller: tabviewController,
        indicatorColor: Colors.orange,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        tabs: [
          Tab(text: "Deskripsi"),
          Tab(text: "Foto"),
          Tab(text: "Harga"),
          Tab(text: "Fasilitas"),
        ],
      ),
    );
  }
}
