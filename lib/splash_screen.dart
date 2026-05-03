import 'dart:async';

import 'package:flutter/material.dart';

import 'role_selection_screen.dart';

class SplashScreen
    extends StatefulWidget {

  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen>
  createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController
  _controller;

  late Animation<double>
  _fadeAnimation;

  late Animation<double>
  _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // 🎬 ANIMATION CONTROLLER
    _controller =
        AnimationController(

          vsync: this,

          duration:
          const Duration(
            seconds: 2,
          ),
        );

    // 🌟 FADE ANIMATION
    _fadeAnimation =
        Tween<double>(
          begin: 0,
          end: 1,
        ).animate(

          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeIn,
          ),
        );

    // 🌟 SCALE ANIMATION
    _scaleAnimation =
        Tween<double>(
          begin: 0.7,
          end: 1,
        ).animate(

          CurvedAnimation(
            parent: _controller,
            curve:
            Curves.elasticOut,
          ),
        );

    // ▶ START ANIMATION
    _controller.forward();

    // ⏳ NAVIGATE AFTER DELAY
    Timer(

      const Duration(
        seconds: 4,
      ),

          () {

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

            builder:
                (context) =>
            const RoleSelectionScreen(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {

    _controller.dispose();

    super.dispose();
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
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
          ),
        ),

        child: Center(

          child: FadeTransition(

            opacity: _fadeAnimation,

            child: ScaleTransition(

              scale: _scaleAnimation,

              child: Column(

                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [

                  // 🌍 APP LOGO
                  Container(

                    padding:
                    const EdgeInsets.all(
                        28),

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
                          color: Colors.green
                              .withOpacity(
                              0.5),

                          blurRadius: 25,
                          spreadRadius: 3,
                        ),
                      ],
                    ),

                    child: const Icon(

                      Icons.map,

                      size: 90,

                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(
                    height: 35,
                  ),

                  // 🌟 APP TITLE
                  const Text(

                    "Campus Navigator",

                    style: TextStyle(

                      color:
                      Colors.white,

                      fontSize: 36,

                      fontWeight:
                      FontWeight.bold,

                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  // 🌟 SUBTITLE
                  const Text(

                    "Smart Campus Navigation",

                    style: TextStyle(

                      color:
                      Colors.white70,

                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(
                    height: 60,
                  ),

                  // ⏳ LOADING
                  Column(

                    children: [

                      const CircularProgressIndicator(
                        color: Colors.green,
                        strokeWidth: 3,
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      Text(

                        "Loading...",

                        style: TextStyle(

                          color:
                          Colors.white
                              .withOpacity(
                              0.8),

                          fontSize: 16,
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
    );
  }
}