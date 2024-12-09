import 'package:flutter/material.dart';
import 'package:flutter_simparta/view/akomodasi/akomodasi.dart';
import 'package:flutter_simparta/view/akomodasi/semua_akomodasi/semua_akomodasi.dart';
import 'package:flutter_simparta/view/berita/berita.dart';
import 'package:flutter_simparta/view/destinasi/destinasi_wisata/destinasi_wisatabahari_screen.dart';
import 'package:flutter_simparta/view/ekonomi_kreatif/ekonomi_kreatif.dart';
import '../view/agenda/agenda_tentang.dart';
import '../view/agenda/agenda_wisata.dart';
import '../view/app_navigation_screen.dart';
import '../view/beranda/beranda_screen.dart';
import '../view/destinasi/destinasi_screen.dart';
import '../view/destinasi/destinasi_tentang/destinasi_tentang_screen.dart';
import '../view/destinasi/destinasi_wisata/destinasi_kampungwisata_screen.dart';
import '../view/destinasi/destinasi_wisata/destinasi_wisataalam_screen.dart';
import '../view/destinasi/destinasi_wisata/destinasi_wisatabelanja_screen.dart';
import '../view/destinasi/destinasi_wisata/destinasi_wisatabuatan_screen.dart';
import '../view/destinasi/destinasi_wisata/destinasi_wisatabudaya_screen.dart';
import '../view/destinasi/destinasi_wisata/destinasi_wisataedukasi_screen.dart';
import '../view/destinasi/destinasi_wisata/destinasi_wisatakuliner_screen.dart';
import '../view/destinasi/destinasi_wisata/destinasi_wisataminat_screen.dart';
import '../view/destinasi/destinasi_wisata/destinasi_wisatareliji_screen.dart';
import '../view/destinasi/destinasi_wisata/destinasi_wisatasejarah_screen.dart';
import '../view/destinasi/semua_destinasi/semua_destinasi.dart';
import '../view/ekonomi_kreatif/ekonomi_tentang/ekonomi_tentang_screen.dart';
import '../view/ekonomi_kreatif/ekonomikreatif/semua_ekonomi_kreatif.dart';
import '../view/splash_screen.dart';
import '../view/akomodasi/cafe_resto/cafe_resto.dart';
import '../view/akomodasi/guest_home/guest_home.dart';
import '../view/akomodasi/homestay/homestay.dart';
import '../view/akomodasi/hotel/hotel.dart';
import '../view/transportasi/transportasi.dart';
import '../view/transportasi/transportasi_tentang.dart';

class AppRoutes {
  static const String splashScreen = '/splash_screen';

  static const String berandaScreen = '/beranda_screen';

  static const String destinasiScreen = '/destinasi_screen';
  static const String destinasiSemuaScreen = '/semua_destinasi';
  static const String destinasiWisataAlamScreen ='/destinasi_wisataalam_screen';
  static const String destinasiWisataBahariScreen ='/destinasi_wisatabahari_screen';
  static const String destinasiWisataBelanjaScreen ='/destinasi_wisatabelanja_screen';
  static const String destinasiWisataBuatanScreen ='/destinasi_wisatabuatan_screen';
  static const String destinasiWisataBudayaScreen ='/destinasi_wisatabudaya_screen';
  static const String destinasiWisataKulinerScreen ='/destinasi_wisatakuliner_screen';
  static const String destinasiWisataEdukasiScreen ='/destinasi_wisataedukasi_screen';
  static const String destinasiWisataRelijiScreen ='/destinasi_wisatareliji_screen';
  static const String destinasiWisataSejarahScreen ='/destinasi_wisatasejarah_screen';
  static const String destinasiWisataMinatKhusus ='/destinasi_wisataminatkhusus_screen';
  static const String destinasiKampungWisataScreen ='/destinasi_kampungwisata_screen';
  static const String destinasiTentangScreen = '/destinasi_tentang_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static const String agendaWisataScreen = '/agenda_wisata';
  static const String agendaTentangScreen = '/agenda_tentang_screen';

  static const String transportasiScreen = '/transportasi';
  static const String transportasiTentangScreen = '/transportasi_tentang_screen';


  static const String akomodasiScreen = '/akomodasi';
  static const String akomodasiSemuaScreen = '/semua_akomodasi';
  static const String akomodasiHotelScreen = '/akomodasi_hotel';
  static const String akomodasiHomestayaScreen = '/akomodasi_homestay';
  static const String akomodasiGuesthomeScreen = '/akomodasi_guesthome';
  static const String akomodasiCaferestoScreen = '/akomodasi_caferesto';

  static const String ekonomiKreatifScreen = '/ekonomi_kreatif';
  static const String kreatifSemuaScreen = '/semua_ekonomi_kreatif';
  static const String arsitekturScreen = '/arsitektur';
  static const String fashionScreen = '/fashion';
  static const String penerbitanScreen = '/penerbitan';
  static const String kriyaScreen = '/kriya';
  static const String musikScreen = '/musik';
  static const String seniPertunjukanScreen = '/seni_pertunjukan';
  static const String aplikasiPengembanganPermainan = '/aplikasi_pengembangan_permainan';
  static const String desainProdukScreen = '/desain_produk';
  static const String filmAnimasiVideo = '/film_animasi_video';
  static const String fotografiScreen = '/fotografi';
  static const String kulinerScreen = '/kuliner';
  static const String seniRupaScreen = '/seni_rupa';
  static const String radioTelevisiScreen = '/radio_televisi';

  static const String ekonomiTentangScreen = '/ekonomi_tentang_screen';

  static const String beritaScreen ='/berita_screen';

  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> routes = {
    
    splashScreen: (context) => SplashScreen(),
    
    berandaScreen: (context) => BerandaScreen(),
    
    destinasiScreen: (context) => DestinasiScreen(),
    destinasiSemuaScreen: (context) => SemuaDestinasiScreen(),
    destinasiWisataAlamScreen: (context) => WisataAlamScreen(),
    destinasiWisataBahariScreen: (context) => WisataBahariSceen(),
    destinasiWisataBelanjaScreen: (context) => WisataBelanjaScreen(),
    destinasiWisataBuatanScreen: (context) => WisataBuatanScreen(),
    destinasiWisataBudayaScreen: (context) => WisataBudayaScreen(),
    destinasiWisataKulinerScreen: (context) => WisataKulinerScreen(),
    destinasiWisataEdukasiScreen: (context) => WisataEdukasiScreen(),
    destinasiWisataRelijiScreen: (context) => WisataRelijiScreen(),
    destinasiWisataSejarahScreen: (context) => WisataSejarahScreen(),
    destinasiWisataMinatKhusus: (context) => WisataMinatKhusus(),
    destinasiKampungWisataScreen: (context) => KampungWisataScreen(),

    destinasiTentangScreen: (context) => DestinasiTentangScreen(detail: null,),

    appNavigationScreen: (context) => AppNavigationScreen(),

    agendaWisataScreen: (context) => AgendaWisataScreen(),
    agendaTentangScreen: (context) => AgendaTentangScreen(detail: null,),

    transportasiScreen: (context) => TransportasiScreen(),
    transportasiTentangScreen: (context) => TransportasiTentangScreen(detail: null,),

    
    akomodasiScreen: (context) => AkomodasiScreen(),
    akomodasiSemuaScreen: (context) => SemuaAkomodasiScreen(),
    akomodasiHotelScreen: (context) => HotelScreen(),
    akomodasiHomestayaScreen: (context) => HomestayScreen(),
    akomodasiGuesthomeScreen: (context) => GuestHomeScreen(),
    akomodasiCaferestoScreen: (context) => CafeRestoScreen(),
    
    ekonomiKreatifScreen: (context) => EkonomiKreatifScreen(detail: null,),
    kreatifSemuaScreen: (context) => SemuaEkonomiKreatif(),
    arsitekturScreen: (context) => SemuaEkonomiKreatif(),
    fashionScreen: (context) => SemuaEkonomiKreatif(),
    penerbitanScreen: (context) => SemuaEkonomiKreatif(),
    kriyaScreen: (context) => SemuaEkonomiKreatif(),
    musikScreen: (context) => SemuaEkonomiKreatif(),
    seniPertunjukanScreen: (context) => SemuaEkonomiKreatif(),
    aplikasiPengembanganPermainan: (context) => SemuaEkonomiKreatif(),
    desainProdukScreen: (context) => SemuaEkonomiKreatif(),
    filmAnimasiVideo: (context) => SemuaEkonomiKreatif(),
    fotografiScreen: (context) => SemuaEkonomiKreatif(),
    kulinerScreen: (context) => SemuaEkonomiKreatif(),
    seniRupaScreen: (context) => SemuaEkonomiKreatif(),
    radioTelevisiScreen: (context) => SemuaEkonomiKreatif(),

    ekonomiTentangScreen: (context) => EkonomiTentangScreen(detail: null,),
    
    beritaScreen: (context) => BeritaScreen(),
    
    initialRoute: (context) => SplashScreen(),
  };
}
