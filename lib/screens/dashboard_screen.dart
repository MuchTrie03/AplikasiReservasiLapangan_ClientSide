import 'package:flutter/material.dart';
import 'lapangan_detail.dart';
import '../services/football_org_API.dart';
import 'player_page.dart'; // Import halaman pemain
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/DatabaseHelper.dart';
import '../models/Reservation.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _selectedIndex = 0; // Indeks item yang dipilih di Bottom Navigation Bar

  // Daftar halaman yang akan ditampilkan di Bottom Navigation Bar
  final List<Widget> _pages = [
    const UserHomePage(), // Halaman Home
    const LeaguePage(), // Halaman Liga Inggris
    const UserReservationPage(), // Halaman Reservasi
    const AboutPage(), // Halaman About (menggantikan Profil)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Perbarui indeks yang dipilih
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Memastikan konten mengisi seluruh layar
      appBar: null, // Hilangkan AppBar
      body: IndexedStack(
        index: _selectedIndex, // Tampilkan halaman sesuai indeks
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Indeks item yang aktif
        onTap: _onItemTapped, // Fungsi yang dipanggil saat item diklik
        backgroundColor:
            const Color.fromARGB(255, 17, 18, 19), // Warna latar belakang
        selectedItemColor: Colors.white, // Warna item yang dipilih
        unselectedItemColor: Colors.white70, // Warna item yang tidak dipilih
        selectedIconTheme:
            const IconThemeData(color: Colors.white), // Warna ikon yang dipilih
        unselectedIconTheme: const IconThemeData(
            color: Colors.white70), // Warna ikon yang tidak dipilih
        selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold), // Gaya teks yang dipilih
        unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal), // Gaya teks yang tidak dipilih
        type: BottomNavigationBarType
            .fixed, // Tetapkan tipe fixed untuk menghindari animasi
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer),
            label: 'Liga',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Reservasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
      ),
    );
  }
}

// halaman homepage
class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 17, 18, 19),
              Color.fromARGB(255, 161, 13, 13)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          // Membuat halaman bisa di-scroll
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header dengan ikon (digeser ke bawah)
                SizedBox(height: screenHeight * 0.05),
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.sports_soccer,
                        size: screenWidth * 0.15,
                        color: Colors.white,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        'Selamat Datang !',
                        style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                        ),
                        child: Text(
                          'Aplikasi ini memudahkan Anda untuk melakukan reservasi lapangan olahraga. '
                          'Cek ketersediaan lapangan di bawah ini dan lakukan reservasi dengan menekan tombol "Reservasi".',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),

                // Fitur Pencarian
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari lapangan...',
                    hintStyle: TextStyle(color: Colors.white70),
                    prefixIcon: Icon(Icons.search, color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: screenHeight * 0.03),

                // GridView untuk menampilkan lapangan
                GridView.builder(
                  shrinkWrap: true, // Agar GridView bisa di-scroll
                  physics:
                      NeverScrollableScrollPhysics(), // Non-aktifkan scroll internal
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    final lapangan = ['Lapangan A', 'Lapangan B'][index];
                    final status = ['Tersedia', 'Dipakai'][index];
                    final harga = ['Rp.150.000', 'Rp.200.000'][index];
                    final deskripsi = [
                      'Lapangan ini adalah lapangan serbaguna yang cocok untuk berbagai jenis olahraga, termasuk futsal, sepak bola, dan bola basket. Dengan permukaan yang rata dan berkualitas tinggi, Lapangan A menawarkan pengalaman bermain yang nyaman dan aman. Dilengkapi dengan pencahayaan yang memadai, lapangan ini dapat digunakan baik siang maupun malam hari.',
                      'Lapangan B dirancang khusus untuk pertandingan futsal dengan ukuran standar internasional. Permukaan lapangan menggunakan rumput sintetis berkualitas tinggi yang memberikan kenyamanan dan mengurangi risiko cedera. Fasilitas pendukung seperti bangku cadangan dan area parkir yang luas membuat Lapangan B menjadi pilihan utama bagi tim futsal.'
                    ][index];
                    final statusColor =
                        status == 'Tersedia' ? Colors.green : Colors.red;

                    return Card(
                      color: Colors.white.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.02),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.sports_soccer,
                              size: screenWidth * 0.18,
                              color: Colors.white.withOpacity(0.7),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              lapangan,
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              'Status: $status',
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: statusColor,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LapanganDetail(
                                      lapanganName: lapangan,
                                      status: status,
                                      harga: harga,
                                      deskripsi: deskripsi,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 161, 13, 13),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Lihat Detail',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.03,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: screenHeight * 0.03),

                // Teks "Lokasi Lapangan" di atas peta
                Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.01),
                  child: Text(
                    'Lokasi Lapangan',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Peta untuk menandai alamat GOR
                Container(
                  height: screenHeight * 0.3, // Tinggi peta
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(12), // Border radius untuk frame
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3), // Warna border
                      width: 2, // Lebar border
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3), // Efek shadow
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(10), // Border radius untuk peta
                    child: FlutterMap(
                      options: MapOptions(
                        center: LatLng(-6.738778, 107.362972), // Koordinat GOR
                        zoom: 13.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.uas.app',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: 80.0,
                              height: 80.0,
                              point: LatLng(
                                  -6.738778, 107.362972), // Koordinat GOR
                              builder: (ctx) => Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// HALAMAN LIGA
class LeaguePage extends StatefulWidget {
  const LeaguePage({super.key});

  @override
  _LeaguePageState createState() => _LeaguePageState();
}

class _LeaguePageState extends State<LeaguePage> {
  List<dynamic> teams = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadTeams();
  }

  Future<void> loadTeams() async {
    try {
      final data = await FootballDataApi.fetchTeams();
      setState(() {
        teams = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 17, 18, 19),
              Color.fromARGB(255, 161, 13, 13)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Jarak di atas judul
              SizedBox(height: screenHeight * 0.04),

              // Judul Halaman
              const Text(
                'Premier League Teams',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Tampilkan loading atau error message
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              else if (errorMessage.isNotEmpty)
                Center(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                )
              else
                // Daftar Tim
                Expanded(
                  child: ListView.builder(
                    physics:
                        const BouncingScrollPhysics(), // Scroll lebih halus
                    itemCount: teams.length,
                    itemBuilder: (context, index) {
                      final team = teams[index];
                      return Card(
                        color: Colors.white.withOpacity(0.1),
                        margin:
                            EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                        child: ListTile(
                          leading: team['crest'] != null
                              ? Image.network(
                                  team['crest'],
                                  width: 40,
                                  height: 40,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    );
                                  },
                                )
                              : const Icon(
                                  Icons.sports_soccer,
                                  color: Colors.white,
                                ),
                          title: Text(
                            team['name'] ?? 'No Name',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Stadium: ${team['venue'] ?? 'Unknown'}',
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                          onTap: () {
                            // Navigasi ke halaman pemain
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlayersPage(
                                  teamId: team['id'], // Kirim ID tim
                                  teamName: team['name'], // Kirim nama tim
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Halaman Reservasi (User)
class UserReservationPage extends StatefulWidget {
  const UserReservationPage({super.key});

  @override
  _UserReservationPageState createState() => _UserReservationPageState();
}

class _UserReservationPageState extends State<UserReservationPage> {
  List<Reservation> userReservations = [];
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    try {
      final reservations = await dbHelper.getReservations();
      setState(() {
        userReservations = reservations;
      });
    } catch (e) {
      print('Error loading reservations: $e'); // Debugging
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 17, 18, 19),
              Color.fromARGB(255, 161, 13, 13)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                'Reservasi Saya',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: userReservations.isEmpty
                    ? const Center(
                        child: Text(
                          'Anda belum melakukan reservasi',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: userReservations.length,
                        itemBuilder: (context, index) {
                          final reservation = userReservations[index];
                          return Card(
                            color: Colors.white.withOpacity(0.1),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              title: Text(
                                reservation.name,
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                'Tanggal: ${reservation.date}, Waktu: ${reservation.time}, Lapangan: ${reservation.field}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Halaman About
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 17, 18, 19),
              Color.fromARGB(255, 161, 13, 13)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Judul Halaman
                const Text(
                  'Tentang Aplikasi',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // Deskripsi Aplikasi
                const Text(
                  'Aplikasi ini dirancang untuk memenuhi tugas pengganti UAS mata kuliah Pemrograman Mobile. '
                  'Berikut link demo aplikasi:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),

                // Teks Link YouTube
                GestureDetector(
                  onTap: () {
                    // Buka link YouTube saat teks diklik
                    const url =
                        'https://youtube.com/playlist?list=PL_XRxkjvTXa2hW3cdbzGtfcjatLOhNdIN&si=h22efbUeCmSNIBE6'; // link youtube
                    launchUrl(Uri.parse(url));
                  },
                  child: const Text(
                    'Tonton Demo di YouTube',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue, // Warna teks biru seperti link
                      decoration:
                          TextDecoration.underline, // Garis bawah seperti link
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Foto Pengembang
                CircleAvatar(
                  radius: 80, // Ukuran lingkaran
                  backgroundImage:
                      AssetImage('assets/img/dev.png'), // Foto pengembang
                ),
                const SizedBox(height: 20),

                // Informasi Developer
                const Text(
                  'Dikembangkan oleh',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Much Trie Harnanto\n152022083',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
