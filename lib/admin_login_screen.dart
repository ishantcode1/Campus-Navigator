import 'package:flutter/material.dart';
import 'admin_dashboard_screen.dart';

class AdminLoginScreen
    extends StatefulWidget {

  const AdminLoginScreen({
    super.key,
  });

  @override
  State<AdminLoginScreen>
  createState() =>
      _AdminLoginScreenState();
}

class _AdminLoginScreenState
    extends State<AdminLoginScreen> {

  final TextEditingController
  _usernameController =
  TextEditingController();

  final TextEditingController
  _passwordController =
  TextEditingController();

  String errorMessage = '';

  // 🔐 LOGIN FUNCTION
  void _login() {

    final username =
        _usernameController.text;

    final password =
        _passwordController.text;

    // 🔐 HARDCODED LOGIN
    if (username == 'admin' &&
        password == '1234') {

      // 🚀 OPEN DASHBOARD
      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder:
              (context) =>
          const AdminDashboardScreen(),
        ),
      );

    } else {

      setState(() {

        errorMessage =
        "Invalid Username or Password";
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        width: double.infinity,

        decoration: const BoxDecoration(

          gradient: LinearGradient(

            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

            colors: [
              Color(0xFF141E30),
              Color(0xFF243B55),
            ],
          ),
        ),

        child: SafeArea(

          child: Center(

            child: SingleChildScrollView(

              child: Padding(

                padding:
                const EdgeInsets.all(
                    25),

                child: Column(

                  children: [

                    // 🌟 ADMIN ICON
                    Container(

                      padding:
                      const EdgeInsets.all(
                          25),

                      decoration:
                      BoxDecoration(

                        shape:
                        BoxShape.circle,

                        color:
                        Colors.white
                            .withOpacity(
                            0.08),

                        boxShadow: [

                          BoxShadow(
                            color: Colors.blue
                                .withOpacity(
                                0.5),

                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),

                      child: const Icon(

                        Icons
                            .admin_panel_settings,

                        size: 70,

                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    // 🌟 TITLE
                    const Text(
                      "Admin Login",

                      style: TextStyle(

                        color: Colors.white,

                        fontSize: 34,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    const Text(
                      "Manage Campus Locations",

                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(
                      height: 50,
                    ),

                    // 👤 USERNAME
                    _buildTextField(

                      controller:
                      _usernameController,

                      hintText:
                      "Username",

                      icon: Icons.person,
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    // 🔒 PASSWORD
                    _buildTextField(

                      controller:
                      _passwordController,

                      hintText:
                      "Password",

                      icon: Icons.lock,

                      obscureText: true,
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    // ❌ ERROR
                    if (errorMessage
                        .isNotEmpty)

                      Text(
                        errorMessage,

                        style:
                        const TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                        ),
                      ),

                    const SizedBox(
                      height: 30,
                    ),

                    // 🚀 LOGIN BUTTON
                    GestureDetector(

                      onTap: _login,

                      child: Container(

                        width:
                        double.infinity,

                        padding:
                        const EdgeInsets.symmetric(
                          vertical: 18,
                        ),

                        decoration:
                        BoxDecoration(

                          borderRadius:
                          BorderRadius.circular(
                              18),

                          gradient:
                          const LinearGradient(

                            colors: [
                              Colors.blue,
                              Colors.lightBlueAccent,
                            ],
                          ),

                          boxShadow: [

                            BoxShadow(
                              color: Colors.blue
                                  .withOpacity(
                                  0.4),

                              blurRadius: 15,
                              offset:
                              const Offset(
                                  0, 5),
                            ),
                          ],
                        ),

                        child: const Center(

                          child: Text(
                            "LOGIN",

                            style: TextStyle(

                              color:
                              Colors.white,

                              fontSize: 18,

                              fontWeight:
                              FontWeight.bold,

                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
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

  // 🌟 PREMIUM TEXTFIELD
  Widget _buildTextField({

    required TextEditingController
    controller,

    required String hintText,

    required IconData icon,

    bool obscureText = false,

  }) {

    return Container(

      decoration: BoxDecoration(

        color:
        Colors.white.withOpacity(
            0.08),

        borderRadius:
        BorderRadius.circular(
            20),

        border: Border.all(
          color:
          Colors.white.withOpacity(
              0.2),
        ),
      ),

      child: TextField(

        controller: controller,

        obscureText: obscureText,

        style: const TextStyle(
          color: Colors.white,
        ),

        decoration: InputDecoration(

          hintText: hintText,

          hintStyle:
          const TextStyle(
            color: Colors.white70,
          ),

          prefixIcon: Icon(
            icon,
            color: Colors.white70,
          ),

          border: InputBorder.none,

          contentPadding:
          const EdgeInsets.symmetric(
            vertical: 20,
          ),
        ),
      ),
    );
  }
}