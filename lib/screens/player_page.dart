// lib/screens/players_page.dart
import 'package:flutter/material.dart';
import '../services/football_org_API.dart'; // Import file API

class PlayersPage extends StatefulWidget {
  final int teamId; // ID tim yang dipilih
  final String teamName; // Nama tim yang dipilih

  const PlayersPage({super.key, required this.teamId, required this.teamName});

  @override
  _PlayersPageState createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  List<dynamic> players = []; // List untuk menyimpan data pemain
  Map<String, dynamic> teamInfo =
      {}; // Informasi tim (bendera, nama klub, dll.)
  bool isLoading = true; // Untuk menandai apakah data sedang dimuat
  String errorMessage = ''; // Untuk menyimpan pesan error jika terjadi

  @override
  void initState() {
    super.initState();
    loadPlayers(); // Panggil fungsi untuk memuat data pemain
  }

  // Fungsi untuk memuat data pemain dan informasi tim
  Future<void> loadPlayers() async {
    try {
      final data = await FootballDataApi.fetchPlayersByTeamId(widget.teamId);
      setState(() {
        players = data['squad']; // Ambil daftar pemain
        teamInfo = {
          'crest': data['crest'], // URL bendera tim
          'name': data['name'], // Nama tim
          'coach': data['coach'], // Nama pelatih
        };
        isLoading = false;

        // Urutkan pemain berdasarkan posisi
        players.sort((a, b) {
          final posA = a['position']?.toLowerCase() ?? '';
          final posB = b['position']?.toLowerCase() ?? '';
          return posA.compareTo(posB);
        });
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  // Fungsi untuk mengubah posisi menjadi singkatan dan warna
  Map<String, dynamic> getPositionInfo(String position) {
    switch (position.toLowerCase()) {
      // Pemain Bertahan (Defender)
      case 'goalkeeper':
        return {
          'abbreviation': 'GK', // Singkatan untuk Goalkeeper
          'color': Colors.blue, // Warna untuk Pemain Bertahan
        };
      case 'defender':
      case 'centre-back':
      case 'defence':
        return {
          'abbreviation': 'CB', // Singkatan untuk Centre-Back
          'color': Colors.blue, // Warna untuk Pemain Bertahan
        };
      case 'left-back':
        return {
          'abbreviation': 'LB', // Singkatan untuk Left-Back
          'color': Colors.blue, // Warna untuk Pemain Bertahan
        };
      case 'right-back':
        return {
          'abbreviation': 'RB', // Singkatan untuk Right-Back
          'color': Colors.blue, // Warna untuk Pemain Bertahan
        };

      // Gelandang (Midfielder)
      case 'midfield':
      case 'midfielder':
        return {
          'abbreviation': 'MF', // Singkatan untuk Midfielder
          'color': Colors.green, // Warna untuk Gelandang
        };
      case 'defensive midfield':
      case 'defensive midfielder':
        return {
          'abbreviation': 'DM', // Singkatan untuk Defensive Midfielder
          'color': Colors.green, // Warna untuk Gelandang
        };
      case 'central midfield':
      case 'central midfielder':
        return {
          'abbreviation': 'CM', // Singkatan untuk Central Midfielder
          'color': Colors.green, // Warna untuk Gelandang
        };
      case 'attacking midfield':
      case 'attacking midfielder':
      case 'centre attacking midfield':
        return {
          'abbreviation': 'CAM', // Singkatan untuk Centre Attacking Midfielder
          'color': Colors.green, // Warna untuk Gelandang
        };

      // Penyerang (Forward)
      case 'left wing':
      case 'left winger':
        return {
          'abbreviation': 'LW', // Singkatan untuk Left Winger
          'color': Colors.red, // Warna untuk Penyerang
        };
      case 'right wing':
      case 'right winger':
        return {
          'abbreviation': 'RW', // Singkatan untuk Right Winger
          'color': Colors.red, // Warna untuk Penyerang
        };
      case 'forward':
      case 'striker':
      case 'centre forward':
      case 'centre-forward':
        return {
          'abbreviation': 'CF', // Singkatan untuk Centre Forward
          'color': Colors.red, // Warna untuk Penyerang
        };
      case 'offence': // Huruf kecil
      case 'Offence': // Huruf besar
        return {
          'abbreviation': 'OF', // Singkatan untuk Offence
          'color': Colors.red, // Warna untuk Penyerang
        };

      // Tambahan untuk posisi lain yang belum terdaftar
      case 'wing-back':
        return {
          'abbreviation': 'WB', // Singkatan untuk Wing-Back
          'color': Colors.blue, // Warna untuk Pemain Bertahan
        };
      case 'sweeper':
        return {
          'abbreviation': 'SW', // Singkatan untuk Sweeper
          'color': Colors.blue, // Warna untuk Pemain Bertahan
        };
      case 'second striker':
        return {
          'abbreviation': 'SS', // Singkatan untuk Second Striker
          'color': Colors.red, // Warna untuk Penyerang
        };
      default:
        return {
          'abbreviation':
              position, // Jika posisi tidak dikenal, gunakan singkatan aslinya
          'color': Colors.grey, // Warna default
        };
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
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Jarak di atas tombol back dan judul
                    const SizedBox(height: 20),

                    // Baris untuk Tombol Back dan Judul
                    Row(
                      children: [
                        // Tombol Back
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(
                                context); // Kembali ke halaman sebelumnya
                          },
                        ),
                        const SizedBox(
                            width: 10), // Jarak antara tombol back dan judul

                        // Judul Halaman (Nama Tim)
                        Text(
                          widget.teamName, // Hanya menampilkan nama tim
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Tampilkan error message jika ada
                    if (errorMessage.isNotEmpty)
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
                      // Card untuk Informasi Tim dan Daftar Pemain
                      Expanded(
                        child: ListView(
                          children: [
                            // Card untuk Informasi Tim
                            Card(
                              color: Colors.white.withOpacity(0.1),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Bendera Tim
                                    if (teamInfo['crest'] != null)
                                      Image.network(
                                        teamInfo['crest'],
                                        width: 100,
                                        height: 100,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.flag,
                                            color: Colors.white,
                                            size: 100,
                                          );
                                        },
                                      )
                                    else
                                      const Icon(
                                        Icons.flag,
                                        color: Colors.white,
                                        size: 100,
                                      ),
                                    const SizedBox(height: 10),

                                    // Nama Tim
                                    Text(
                                      teamInfo['name'] ??
                                          'Nama Tim Tidak Tersedia',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 10),

                                    // Nama Pelatih
                                    Text(
                                      'Pelatih: ${teamInfo['coach']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Daftar Pemain
                            const Text(
                              'Daftar Pemain:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // List Pemain
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: players.length,
                              itemBuilder: (context, index) {
                                final player = players[index];
                                final name = player['name'] ??
                                    'No Name'; // Nama pemain (default: 'No Name')
                                final position = player['position'] ??
                                    'Unknown'; // Posisi pemain (default: 'Unknown')

                                // Dapatkan informasi posisi (singkatan dan warna)
                                final positionInfo = getPositionInfo(position);

                                return Card(
                                  color: Colors.white.withOpacity(0.1),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: positionInfo[
                                          'color'], // Warna berdasarkan posisi
                                      child: Text(
                                        positionInfo[
                                            'abbreviation'], // Tampilkan singkatan posisi
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Posisi: $position',
                                      style: TextStyle(
                                        color: positionInfo[
                                            'color'], // Warna posisi
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
