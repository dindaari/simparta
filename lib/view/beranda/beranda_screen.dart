import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/custom_app_bar.dart';

// ignore_for_file: must_be_immutable

class BerandaScreen extends StatefulWidget {
  BerandaScreen({Key? key}) : super(key: key);

  @override
  _BerandaScreenState createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  final TextEditingController searchController = TextEditingController();

  // List destinasi, agenda wisata, dan berita with dynamic types
  List<Map<String, dynamic>> destinations = [];
  List<Map<String, dynamic>> events = [];
  List<Map<String, dynamic>> news = [];

  // Filtered lists
  List<Map<String, dynamic>> filteredDestinations = [];
  List<Map<String, dynamic>> filteredEvents = [];
  List<Map<String, dynamic>> filteredNews = [];

  @override
  void initState() {
    super.initState();
    fetchDestinations();
    fetchNews();
    fetchEvents();
    filteredEvents = List.from(events);
    filteredNews = List.from(news);
    searchController.addListener(_filterContent);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchDestinations() async {
    const String apiUrl =
        'http://demo.technophoria.co.id/simparta_pekalongan/api/rest_data?thisref=obyek';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          destinations = data
              .where((item) => item["obyek_jenis"] == "destinasi")
              .map((item) => {
                    "imagePath":
                        "http://demo.technophoria.co.id/simparta_pekalongan/" +
                            (item["obyek_file_small"] ?? ""),
                    "title": item["obyek_nama"] ?? "",
                    "description": item["obyek_keterangan"] ?? "",
                  })
              .toList();
          filteredDestinations = List.from(destinations);
        });
      } else {
        print(
            "Failed to load destinations. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching destinations: $error");
    }
  }

  Future<void> fetchNews() async {
    const String apiUrl =
        'http://demo.technophoria.co.id/simparta_pekalongan/api/rest_data?thisref=berita';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          news = data.map((item) {
            String imagePath =
                item["berita_file"] != null && item["berita_file"].isNotEmpty
                    ? "http://demo.technophoria.co.id/simparta_pekalongan/" +
                        item["berita_file"]
                    : ImageConstant.imgSimpartaSampul1; // Gambar default

            return {
              "imagePath": imagePath,
              "title": item["berita_nama"] ?? "",
              "date": item["berita_time"] ?? "",
              "deskripsi": item["berita_deskripsi"] ?? "",
            };
          }).toList();
          filteredNews = List.from(news);
        });
      } else {
        print("Failed to load news. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching news: $error");
    }
  }

  Future<void> fetchEvents() async {
    const String apiUrl =
        'http://demo.technophoria.co.id/simparta_pekalongan/api/rest_data?thisref=event';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          events = data.map((item) {
            String imagePath = item["event_file_small"] != null &&
                    item["event_file_small"].isNotEmpty
                ? "http://demo.technophoria.co.id/simparta_pekalongan/" +
                    item["event_file_small"]
                : ImageConstant.imgSimpartaSampul1; // Gambar default

            return {
              "imagePath": imagePath,
              "title": item["event_nama"] ?? "",
              "date": item["event_tgl_mulai"] ?? "",
              "location": item["event_alamat"] ?? "",
            };
          }).toList();
          filteredEvents = List.from(events);
        });
      } else {
        print("Failed to load events. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching events: $error");
    }
  }

  // Method for filtering content
  void _filterContent() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredDestinations = destinations.where((item) {
        return (item["title"]?.toLowerCase().contains(query) ?? false);
      }).toList();

      filteredEvents = events.where((item) {
        return (item["title"]?.toLowerCase().contains(query) ?? false);
      }).toList();

      filteredNews = news.where((item) {
        return (item["title"]?.toLowerCase().contains(query) ?? false);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildChevronSection(),
              SizedBox(height: 16.h),
              buildSearchSection(),
              SizedBox(height: 16.h),
              _buildDestinations(context),
              SizedBox(height: 16.h),
              _buildTourismAgenda(),
              SizedBox(height: 16.h),
              _buildBerita(),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNavigation(context),
      ),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: Container(
        width: double.infinity, // Ensure the container takes full width
        height: kToolbarHeight, // Set height to match AppBar
        child: Stack(
          children: [
            // Background debug color
            Positioned.fill(
              child: Container(
                color: Colors.blueGrey, // Temporary debug color
                child: Image.asset(
                  'assets/images/bg_logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Logo debug color
            Positioned(
              left: 10.0,
              top: 3.0,
              child: Container(
                width: 150,
                height: 50,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChevronSection() {
    PageController _pageController = PageController();

    return SizedBox(
      height: 172.h,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView(
            controller: _pageController,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgSimpartaSampul1,
                height: 172.h,
                width: double.maxFinite,
              ),
              CustomImageView(
                imagePath: ImageConstant.imgSimpartaSampul2,
                height: 172.h,
                width: double.maxFinite,
              ),
              CustomImageView(
                imagePath: ImageConstant.imgSimpartaSampul3,
                height: 172.h,
                width: double.maxFinite,
              ),
            ],
          ),
          Positioned(
            left: 10.h,
            child: GestureDetector(
              onTap: () {
                _pageController.previousPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
              child: CustomImageView(
                imagePath: ImageConstant.imgChevronRight,
                height: 16.h,
                width: 28.h,
              ),
            ),
          ),
          Positioned(
            right: 10.h,
            child: GestureDetector(
              onTap: () {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
              child: CustomImageView(
                imagePath: ImageConstant.imgChevronLeft,
                height: 16.h,
                width: 28.h,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: SizedBox(
        width: double.infinity, // Atur lebar kolom pencarian di sini jika perlu
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: "Search",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.h),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
                vertical: 8.h,
                horizontal: 12.h), // Atur padding di dalam TextField
          ),
          style: TextStyle(fontSize: 14.h), // Atur ukuran teks jika perlu
        ),
      ),
    );
  }

  Widget _buildDestinations(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Destinasi",
                style: TextStyle(fontSize: 16.h, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, AppRoutes.destinasiSemuaScreen);
                    },
                    child: Row(
                      children: [
                        Text(
                          "Lainnya",
                          style: TextStyle(fontSize: 14.h, color: Colors.blue),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.blue,
                          size: 18.h,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filteredDestinations.map((destination) {
              return _buildDestinationCard(
                context: context,
                imagePath: destination["imagePath"] ?? "",
                title: destination["title"] ?? "",
                description: destination["description"] ?? "",
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDestinationCard({
    required BuildContext context,
    required String imagePath,
    required String title,
    required String description,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.destinasiTentangScreen,
            arguments: {
              'title': title,
              'description': description,
              'imagePath': imagePath,
            });
        print("$title tapped");
      },
      child: Container(
        width: 250.h,
        height: 150.h,
        margin: EdgeInsets.only(left: 16.h),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.h),
              child: Image.network(
                imagePath,
                fit: BoxFit.cover,
                height: 150.h,
                width: 250.h,
                errorBuilder: (context, error, stackTrace) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12.h),
                    child: Image.asset(
                      ImageConstant.imgSimpartaSampul1,
                      fit: BoxFit.cover,
                      height: 150.h,
                      width: 250.h,
                    ),
                  );
                },
                loadingBuilder: (context, child, progress) {
                  if (progress == null) {
                    return child;
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.h),
                color: Colors.black.withOpacity(0.4),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.h,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.h,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTourismAgenda() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Agenda Wisata",
                  style:
                      TextStyle(fontSize: 16.h, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.agendaWisataScreen);
                },
                child: Row(
                  children: [
                    Text("Lainnya",
                        style: TextStyle(fontSize: 14.h, color: Colors.blue)),
                    Icon(Icons.chevron_right, color: Colors.blue, size: 18.h),
                  ],
                ),
              ),
            ],
          ),
        ),
        // List agenda wisata yang difilter
        Column(
          children: filteredEvents.map((event) {
            return _buildAgendaCard(
              context: context,
              imagePath: event["imagePath"] ?? "", // Menangani nilai null
              title:
                  event["title"] ?? "Tidak ada judul", // Menangani nilai null
              date:
                  event["date"] ?? "Tidak ada tanggal", // Menangani nilai null
              location: event["location"] ??
                  "Tidak ada lokasi", // Menangani nilai null
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBerita() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Berita",
                  style:
                      TextStyle(fontSize: 18.h, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.beritaScreen);
                },
                child: Row(
                  children: [
                    Text("Lainnya",
                        style: TextStyle(fontSize: 14.h, color: Colors.blue)),
                    Icon(Icons.chevron_right, color: Colors.blue, size: 18.h),
                  ],
                ),
              ),
            ],
          ),
        ),
        // List berita yang difilter
        Column(
          children: filteredNews.take(2).map((newsItem) {
            return _buildAgendaCard(
              context: context,
              imagePath: newsItem["imagePath"] ?? "", // Menangani nilai null
              title: newsItem["title"] ??
                  "Tidak ada judul", // Menangani nilai null
              date: newsItem["date"] ??
                  "Tidak ada tanggal", // Menangani nilai null
              location: newsItem["location"] ??
                  "Tidak ada lokasi", // Menangani nilai null
            );
          }).toList(),
        ),
      ],
    );
  }

Widget _buildAgendaCard({
  required String imagePath,
  required String title,
  required String date,
  required String location,
  required BuildContext context, // Parameter context
}) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, AppRoutes.destinasiTentangScreen); // Navigasi menggunakan route named
      print("$title tapped"); // Menampilkan pesan di konsol
    },
    child: Padding( // Menambahkan padding di sekitar Row
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
      child: Row(
        children: [
          Container(
            width: 80.h,
            height: 80.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.h),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.h),
              child: Image.network(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    ImageConstant.imgSimpartaSampul1, // Gambar default
                    fit: BoxFit.cover,
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 10.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.h,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10.h,
                  ),
                ),
                Text(
                  location,
                  style: TextStyle(
                    color: Colors.grey,
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
