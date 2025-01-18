import 'dart:convert';
import 'package:http/http.dart' as http;

class FootballDataApi {
  static const String apiKey = '9bede9c89cd8487498f9ddce2afa7e80';
  static const String baseUrl = 'https://api.football-data.org/v4';

  // Fungsi untuk mengambil data tim dari API
  static Future<List<dynamic>> fetchTeams() async {
    final url = Uri.parse('$baseUrl/competitions/PL/teams');
    try {
      final response = await http.get(
        url,
        headers: {'X-Auth-Token': apiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['teams']; // Mengembalikan list tim
      } else {
        throw Exception('Gagal mengambil data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Fungsi untuk mengambil data pemain dan informasi tim berdasarkan ID tim
  static Future<Map<String, dynamic>> fetchPlayersByTeamId(int teamId) async {
    final url = Uri.parse('$baseUrl/teams/$teamId');
    try {
      final response = await http.get(
        url,
        headers: {'X-Auth-Token': apiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Ambil informasi tim (bendera, nama tim, stadion, pelatih) dan daftar pemain
        return {
          'crest':
              data['crest'] ?? '', // URL bendera tim (default: string kosong)
          'name': data['name'] ??
              'Nama Tim Tidak Tersedia', // Nama tim (default: string)
          'venue': data['venue'] ??
              'Stadion Tidak Diketahui', // Nama stadion (default: string)
          'coach': data['coach']?['name'] ??
              'Pelatih Tidak Diketahui', // Nama pelatih (default: string)
          'squad': data['squad'] ?? [], // Daftar pemain (default: list kosong)
        };
      } else {
        throw Exception('Gagal mengambil data pemain: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
