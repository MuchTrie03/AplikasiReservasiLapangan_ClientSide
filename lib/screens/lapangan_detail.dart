import 'package:flutter/material.dart';
import '../models/Reservation.dart';
import '../models/DatabaseHelper.dart';

class LapanganDetail extends StatefulWidget {
  final String lapanganName;
  final String status;
  final String harga;
  final String deskripsi;

  const LapanganDetail({
    Key? key,
    required this.lapanganName,
    required this.status,
    required this.harga,
    required this.deskripsi,
  }) : super(key: key);

  @override
  _LapanganDetailState createState() => _LapanganDetailState();
}

class _LapanganDetailState extends State<LapanganDetail> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedField;

  // Fungsi untuk memformat waktu dengan leading zero
  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _selectDate(
      BuildContext context, Function setStateDialog) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color.fromARGB(255, 161, 13, 13),
              onPrimary: Colors.white,
              surface: Color.fromARGB(255, 17, 18, 19),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color.fromARGB(255, 17, 18, 19),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      setStateDialog(() {});
    }
  }

  Future<void> _selectTime(
      BuildContext context, Function setStateDialog) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color.fromARGB(255, 161, 13, 13),
              onPrimary: Colors.white,
              surface: Color.fromARGB(255, 17, 18, 19),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color.fromARGB(255, 17, 18, 19),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
      setStateDialog(() {});
    }
  }

  void _showReservationForm() {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: const Color.fromARGB(255, 17, 18, 19),
              title: const Text(
                'Tambah Reservasi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Input Nama Pemesan
                    TextField(
                      controller: nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Nama Pemesan',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Pilih Tanggal
                    ListTile(
                      leading:
                          const Icon(Icons.calendar_today, color: Colors.white),
                      title: const Text(
                        'Pilih Tanggal',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        selectedDate != null
                            ? "${selectedDate!.toLocal()}".split(' ')[0]
                            : 'Belum dipilih',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      onTap: () async {
                        await _selectDate(context, setStateDialog);
                      },
                    ),
                    const SizedBox(height: 10),
                    // Pilih Waktu
                    ListTile(
                      leading:
                          const Icon(Icons.access_time, color: Colors.white),
                      title: const Text(
                        'Pilih Waktu',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        selectedTime != null
                            ? _formatTime(selectedTime!)
                            : 'Belum dipilih',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      onTap: () async {
                        await _selectTime(context, setStateDialog);
                      },
                    ),
                    const SizedBox(height: 10),
                    // Dropdown untuk Pilih Lapangan
                    DropdownButtonFormField<String>(
                      value: selectedField,
                      dropdownColor: const Color.fromARGB(255, 17, 18, 19),
                      decoration: const InputDecoration(
                        labelText: 'Lapangan',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      items: ['Lapangan A', 'Lapangan B'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setStateDialog(() {
                          selectedField = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                // Tombol Batal
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                // Tombol Simpan
                TextButton(
                  onPressed: () async {
                    if (nameController.text.isNotEmpty &&
                        selectedDate != null &&
                        selectedTime != null &&
                        selectedField != null) {
                      try {
                        // Simpan reservasi ke SQLite
                        final reservation = Reservation(
                          name: nameController.text,
                          date:
                              selectedDate!.toLocal().toString().split(' ')[0],
                          time: _formatTime(selectedTime!),
                          field: selectedField!,
                        );

                        final dbHelper = DatabaseHelper();
                        await dbHelper.insertReservation(reservation);

                        // Tampilkan pesan sukses
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Reservasi berhasil disimpan!'),
                          ),
                        );

                        Navigator.pop(context);
                      } catch (e) {
                        // Tampilkan pesan error jika gagal
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Gagal menyimpan reservasi: $e'),
                          ),
                        );
                      }
                    } else {
                      // Tampilkan pesan jika ada field yang belum diisi
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Harap isi semua field!'),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Simpan',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
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
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.04),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    'Detail Lapangan',
                    style: TextStyle(
                      fontSize: screenWidth * 0.065,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              Card(
                color: Colors.white.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nama Lapangan:',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        widget.lapanganName,
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        'Status:',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        widget.status,
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: widget.status == 'Tersedia'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        'Harga Sewa per Jam:',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        widget.harga,
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        'Deskripsi:',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        widget.deskripsi,
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Center(
                        child: ElevatedButton(
                          onPressed: _showReservationForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 161, 13, 13),
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.1,
                              vertical: screenHeight * 0.02,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Reservasi Sekarang',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
}
