import 'package:flutter/material.dart';
import 'dashboard_screen.dart'; // Pastikan import ke dashboard_screen.dart sudah benar

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool passToggle = true;

  // Dummy credentials for login simulation
  final String correctEmail = "much@gmail.com";
  final String correctPassword = "123456";

  @override
  void dispose() {
    // Dispose of controllers to avoid memory leaks
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Memastikan konten mengisi seluruh layar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // AppBar transparan
        elevation: 0, // Menghilangkan shadow
      ),
      body: Container(
        width: double.infinity, // Mengisi lebar layar
        height: double.infinity, // Mengisi tinggi layar
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Pusatkan vertikal
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Pusatkan horizontal
                  children: [
                    // Gambar avatar/logo
                    Image.asset(
                      "assets/img/logo2.png", // Pastikan path sudah benar
                      height: 400, // Ukuran logo diperbesar
                    ),
                    const SizedBox(height: 10),

                    // Input email
                    SizedBox(
                      width: double.infinity, // Mengisi lebar parent
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: const TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white70),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white70),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon:
                              const Icon(Icons.email, color: Colors.white70),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                              .hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Input password
                    SizedBox(
                      width: double.infinity, // Mengisi lebar parent
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: passController,
                        obscureText: passToggle,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: const TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white70),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white70),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.white70),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                passToggle = !passToggle;
                              });
                            },
                            child: Icon(
                              passToggle
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Tombol login
                    SizedBox(
                      width: double.infinity, // Mengisi lebar parent
                      child: InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            if (emailController.text == correctEmail &&
                                passController.text == correctPassword) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Login Successful")),
                              );
                              emailController.clear();
                              passController.clear();

                              // Navigasi ke Dashboard setelah login berhasil
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const UserDashboard()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Invalid credentials")),
                              );
                            }
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 161, 13, 13),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              "Log In",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Link untuk sign up
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(fontSize: 17, color: Colors.white70),
                        ),
                        TextButton(
                          onPressed: () {
                            // Tambahkan navigasi ke halaman pendaftaran jika ada
                          },
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
