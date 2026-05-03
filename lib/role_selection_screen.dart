import 'package:flutter/material.dart';

import 'main.dart';
import 'admin_login_screen.dart';

class RoleSelectionScreen
    extends StatelessWidget {

  const RoleSelectionScreen({
    super.key,
  });

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
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
          ),
        ),

        child: SafeArea(

          child: Column(

            mainAxisAlignment:
            MainAxisAlignment.center,

            children: [

              // 🌟 APP ICON
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
                      0.1),

                  boxShadow: [

                    BoxShadow(
                      color: Colors.green
                          .withOpacity(
                          0.5),

                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),

                child: const Icon(
                  Icons.map,

                  size: 70,

                  color: Colors.green,
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              // 🌟 TITLE
              const Text(
                "Campus Navigator",

                style: TextStyle(

                  color: Colors.white,

                  fontSize: 34,

                  fontWeight:
                  FontWeight.bold,

                  letterSpacing: 1,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              const Text(
                "Navigate Your Campus Smartly",

                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              const SizedBox(
                height: 60,
              ),

              // 👨‍🎓 USER BUTTON
              _buildRoleCard(

                context: context,

                title: "Continue as User",

                subtitle:
                "Search & Navigate Locations",

                icon: Icons.person,

                color: Colors.green,

                onTap: () {

                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder:
                          (context) =>
                      const MapScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(
                height: 25,
              ),

              // 👨‍💼 ADMIN BUTTON
              _buildRoleCard(

                context: context,

                title: "Continue as Admin",

                subtitle:
                "Manage Campus Locations",

                icon:
                Icons.admin_panel_settings,

                color: Colors.blue,

                onTap: () {

                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder:
                          (context) =>
                      const AdminLoginScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🌟 PREMIUM CARD
  Widget _buildRoleCard({

    required BuildContext context,

    required String title,

    required String subtitle,

    required IconData icon,

    required Color color,

    required VoidCallback onTap,

  }) {

    return GestureDetector(

      onTap: onTap,

      child: Container(

        width: MediaQuery.of(context)
            .size
            .width *
            0.85,

        padding:
        const EdgeInsets.all(20),

        decoration: BoxDecoration(

          borderRadius:
          BorderRadius.circular(
              25),

          color:
          Colors.white.withOpacity(
              0.08),

          border: Border.all(
            color:
            Colors.white.withOpacity(
                0.2),
          ),

          boxShadow: [

            BoxShadow(
              color:
              color.withOpacity(0.3),

              blurRadius: 20,
              spreadRadius: 1,
            ),
          ],
        ),

        child: Row(

          children: [

            // 🌟 ICON
            Container(

              padding:
              const EdgeInsets.all(
                  15),

              decoration:
              BoxDecoration(

                color:
                color.withOpacity(
                    0.2),

                shape:
                BoxShape.circle,
              ),

              child: Icon(
                icon,

                color: color,

                size: 35,
              ),
            ),

            const SizedBox(
              width: 20,
            ),

            // 🌟 TEXT
            Expanded(

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment
                    .start,

                children: [

                  Text(
                    title,

                    style:
                    const TextStyle(

                      color:
                      Colors.white,

                      fontSize: 20,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  Text(
                    subtitle,

                    style:
                    const TextStyle(
                      color:
                      Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // 🌟 ARROW
            const Icon(
              Icons.arrow_forward_ios,

              color: Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}