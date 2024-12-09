import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/image_constant.dart';

class EkonomiTentangScreen extends StatefulWidget {
  final dynamic detail;

  const EkonomiTentangScreen({Key? key, required this.detail})
      : super(key: key);

  @override
  EkonomiTentangScreenState createState() => EkonomiTentangScreenState();
}

class EkonomiTentangScreenState extends State<EkonomiTentangScreen>
    with TickerProviderStateMixin {
  late TabController tabviewController;
  Completer<GoogleMapController> googleMapController = Completer();
  LatLng _currentLocation = LatLng(0.0, 0.0);
  List<LatLng> _locations = [];
  List<String> _photos = [];
  List<dynamic> _harga = [];
  List<dynamic> _fasilitas = [];
  Map<String, dynamic> dataDetails = {};

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 4, vsync: this);
    fetchLocationData();
    fetchPhotoData();
    fetchHargaData();
    fetchFasilitasData();

    // Assuming widget.detail contains the necessary data for obyekJenis and obyekId
    String obyekJenis =
        widget.detail['obyek_jenis'] ?? ''; // Update with actual key
    String obyekId = (widget.detail['obyek_id'] is String)
        ? widget.detail['obyek_id']
        : widget.detail['obyek_id'].toString();
    fetchDataDetails(obyekJenis, obyekId); // Fetch data details
  }

  Future<void> fetchLocationData() async {
    const String apiUrl =
        'http://demo.technophoria.co.id/simparta_pekalongan/api/rest_data?thisref=obyek';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final locationData = data[0];
          setState(() {
            _currentLocation = LatLng(
              double.tryParse(locationData["obyek_lat"] ?? "0.0") ?? 0.0,
              double.tryParse(locationData["obyek_lan"] ?? "0.0") ?? 0.0,
            );
            _locations = data.map((item) {
              return LatLng(
                double.tryParse(item["obyek_lat"] ?? "0.0") ?? 0.0,
                double.tryParse(item["obyek_lan"] ?? "0.0") ?? 0.0,
              );
            }).toList();
          });

          final GoogleMapController controller =
              await googleMapController.future;
          controller.animateCamera(
              CameraUpdate.newLatLngZoom(_currentLocation, 14.4746));
        }
      } else {
        print(
            "Failed to load location data. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching location data: $error");
    }
  }

  Future<void> fetchPhotoData() async {
    const String apiUrl =
        'http://demo.technophoria.co.id/simparta_pekalongan/api/rest_data?thisref=obyek';

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
    const String apiUrl =
        'http://demo.technophoria.co.id/simparta_pekalongan/api/rest_data?thisref=harga';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          _harga = json.decode(response.body);
        });
      } else {
        print("Failed to load harga data. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching harga data: $error");
    }
  }

  Future<void> fetchFasilitasData() async {
    const String apiUrl =
        'http://demo.technophoria.co.id/simparta_pekalongan/api/rest_data?thisref=fasilitas';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Filter data untuk mengambil hanya yang memiliki obyek_jenis 'ekonomi_kreatif'
        final List<dynamic> filteredData = data
            .where((item) => item['obyek_jenis'] == 'ekonomi_kreatif')
            .toList();

        setState(() {
          // Memperbarui _fasilitas berdasarkan hasil filter
          _fasilitas =
              filteredData.map((item) => item['status_fasilitas']).toList();
        });
      } else {
        print(
            "Failed to load fasilitas data. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching fasilitas data: $error");
    }
  }

  // Fetching Data Details
  Future<void> fetchDataDetails(String obyekJenis, String obyekId) async {
    final response = await http.get(Uri.parse(
        'http://demo.technophoria.co.id/simparta_pekalongan/api/rest_data?thisref=obyek&obyek_jenis=$obyekJenis&obyek_id=$obyekId'));

    if (response.statusCode == 200) {
      final data =
          json.decode(response.body)[0]; // Assuming the data is inside a list

      setState(() {
        dataDetails = {
          "nama_wisata": data["obyek_nama"] ?? "",
          "deskripsi_wisata": data["obyek_deskripsi"] ?? "",
          "telp": data["obyek_telpon"] ?? "",
          "email": data["obyek_email"] ?? "",
          "website": data["obyek_website"] ?? "",
          "alamat": data["obyek_alamat"] ?? "",
          "latitude": data["obyek_lat"] ?? "",
          "longitude": data["obyek_lan"] ?? ""
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
                padding: EdgeInsets.symmetric(
                    horizontal:
                        mediaQuery.width * 0.05), // Padding kiri dan kanan
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Membuat konten rata kiri
                  children: [
                    SizedBox(height: mediaQuery.height * 0.01),
                    _buildLocationSection(mediaQuery),
                    SizedBox(
                      height: 16,
                    ),
                    if (dataDetails.isNotEmpty) ...[
                      // Nama Wisata
                      Text(
                        "Nama Wisata:",
                        style: TextStyle(
                          fontSize: 18, // Ukuran font 18 untuk judul kategori
                          fontWeight:
                              FontWeight.bold, // Bold untuk judul kategori
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5),
                      Text(
                        dataDetails['nama_wisata'] ?? "Nama tidak tersedia",
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 20), // Jarak antar kategori

                      // Deskripsi Wisata
                      Text(
                        "Deskripsi Wisata:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5),
                      Text(
                        dataDetails['deskripsi_wisata'] ??
                            "Deskripsi tidak tersedia",
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 20),

                      // Telepon
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
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 20),

                      // Email
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
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 20),

                      // Website
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
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 20),

                      // Alamat
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
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 20),

                      // Latitude
                      Text(
                        "Latitude:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5),
                      Text(
                        dataDetails['latitude'] ?? "Latitude tidak tersedia",
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 20),

                      // Longitude
                      Text(
                        "Longitude:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5),
                      Text(
                        dataDetails['longitude'] ?? "Longitude tidak tersedia",
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

  Widget _buildImageStack(Size mediaQuery) {
    return SizedBox(
      height: mediaQuery.height * 0.2,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.center,
        children: [
          widget.detail['obyek_file_small'] != null &&
                  widget.detail['obyek_file_small'].isNotEmpty
              ? Image.network(
                  'http://demo.technophoria.co.id/simparta_pekalongan/${widget.detail['obyek_file_small']}',
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

  Widget _buildTabview(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: TabBar(
        controller: tabviewController,
        labelPadding: EdgeInsets.zero,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        tabs: [
          Tab(child: Text("Tentang")),
          Tab(child: Text("Foto")),
          Tab(child: Text("Harga")),
          Tab(child: Text("Fasilitas")),
        ],
      ),
    );
  }

  Widget _buildHargaSection() {
    if (_harga.isEmpty) {
      return Center(
        child:
            CircularProgressIndicator(), // Show loading if harga data is empty
      );
    }

    return ListView.builder(
      itemCount: _harga.length,
      itemBuilder: (context, index) {
        final hargaItem = _harga[index];
        return ListTile(
          title: Text(hargaItem['harga_nama']),
          subtitle: Text(hargaItem['harga_keterangan']),
          trailing: Text(hargaItem['harga_rupiah'].toString()),
        );
      },
    );
  }

  Widget _buildFasilitasSection() {
    if (_fasilitas.isEmpty) {
      return Center(
        child:
            CircularProgressIndicator(), // Show loading if fasilitas data is empty
      );
    }

    return ListView.builder(
      itemCount: _fasilitas.length,
      itemBuilder: (context, index) {
        final fasilitasItem = _fasilitas[index];
        return ListTile(
          title: Text(
              fasilitasItem['nama_fasilitas'] ?? 'Fasilitas Tidak Diketahui'),
          trailing: Icon(
            fasilitasItem['fasilitas_jumlah'] == 'tersedia'
                ? Icons.check_circle
                : Icons.cancel,
            color: fasilitasItem['fasilitas_jumlah'] == 'tersedia'
                ? Colors.green
                : Colors.red,
          ),
        );
      },
    );
  }

  Widget _buildLocationSection(Size mediaQuery) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(
          left: mediaQuery.width * 0.05, right: mediaQuery.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Lokasi",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: mediaQuery.height * 0.015),
          SizedBox(
            height: mediaQuery.height * 0.25, // Sesuaikan ukuran peta
            width: double.infinity,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: _currentLocation,
                zoom: 14.4746,
              ),
              onMapCreated: (GoogleMapController controller) {
                googleMapController.complete(controller);
              },
              markers: _locations.map((location) {
                return Marker(
                  markerId: MarkerId(location.toString()),
                  position: location,
                );
              }).toSet(),
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
}
