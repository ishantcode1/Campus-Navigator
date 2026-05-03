import 'package:flutter/material.dart';

import 'add_location_screen.dart';
import 'view_locations_screen.dart';
import 'delete_location_screen.dart';

class AdminDashboardScreen
    extends StatelessWidget {

  const AdminDashboardScreen({
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

          child: Padding(

            padding:
            const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment
                  .start,

              children: [

                // 🌟 HEADER
                Row(

                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,

                  children: [

                    const Column(

                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [

                        Text(
                          "Admin Dashboard",

                          style: TextStyle(

                            color:
                            Colors.white,

                            fontSize: 34,

                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        SizedBox(
                          height: 8,
                        ),

                        Text(
                          "Manage Campus Locations",

                          style: TextStyle(
                            color:
                            Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    // 🚪 LOGOUT BUTTON
                    Container(

                      decoration:
                      BoxDecoration(

                        color:
                        Colors.red
                            .withOpacity(
                            0.15),

                        borderRadius:
                        BorderRadius.circular(
                            15),
                      ),

                      child: IconButton(

                        onPressed: () {

                          Navigator.pop(
                              context);
                        },

                        icon: const Icon(
                          Icons.logout,

                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 50,
                ),

                // ➕ ADD LOCATION
                _buildDashboardCard(

                  title:
                  "Add Location",

                  subtitle:
                  "Add new campus locations",

                  icon:
                  Icons.add_location_alt,

                  color: Colors.green,

                  onTap: () {

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder:
                            (context) =>
                        const AddLocationScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(
                  height: 30,
                ),

                // 📍 VIEW LOCATIONS
                _buildDashboardCard(

                  title:
                  "View Locations",

                  subtitle:
                  "See all saved locations",

                  icon:
                  Icons.location_on,

                  color: Colors.blue,

                  onTap: () {

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder:
                            (context) =>
                        const ViewLocationsScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(
                  height: 30,
                ),

                // 🗑 DELETE LOCATION
                _buildDashboardCard(

                  title:
                  "Delete Location",

                  subtitle:
                  "Remove existing locations",

                  icon:
                  Icons.delete,

                  color: Colors.red,

                  onTap: () {

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder:
                            (context) =>
                        const DeleteLocationScreen(),
                      ),
                    );
                  },
                ),

                // 🌟 EXTRA SPACE BALANCE
                const Spacer(),

                Center(

                  child: Text(

                    "Campus Navigator Admin Panel",

                    style: TextStyle(

                      color:
                      Colors.white
                          .withOpacity(
                          0.5),

                      fontSize: 14,

                      letterSpacing: 1,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🌟 PREMIUM CARD
  Widget _buildDashboardCard({

    required String title,

    required String subtitle,

    required IconData icon,

    required Color color,

    required VoidCallback onTap,

  }) {

    return GestureDetector(

      onTap: onTap,

      child: AnimatedContainer(

        duration:
        const Duration(
          milliseconds: 250,
        ),

        width: double.infinity,

        padding:
        const EdgeInsets.all(
            22),

        decoration: BoxDecoration(

          borderRadius:
          BorderRadius.circular(
              28),

          color:
          Colors.white.withOpacity(
              0.08),

          border: Border.all(
            color:
            Colors.white.withOpacity(
                0.15),
          ),

          boxShadow: [

            BoxShadow(
              color:
              color.withOpacity(
                  0.28),

              blurRadius: 25,
              spreadRadius: 2,
            ),
          ],
        ),

        child: Row(

          children: [

            // 🌟 ICON
            Container(

              padding:
              const EdgeInsets.all(
                  18),

              decoration:
              BoxDecoration(

                shape:
                BoxShape.circle,

                color:
                color.withOpacity(
                    0.2),
              ),

              child: Icon(
                icon,

                color: color,

                size: 35,
              ),
            ),

            const SizedBox(
              width: 22,
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

                      fontSize: 24,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  Text(
                    subtitle,

                    style:
                    const TextStyle(

                      color:
                      Colors.white70,

                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            // 🌟 ARROW
            const Icon(
              Icons.arrow_forward_ios,

              color: Colors.white70,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}