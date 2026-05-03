import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddLocationScreen
    extends StatefulWidget {

  const AddLocationScreen({
    super.key,
  });

  @override
  State<AddLocationScreen>
  createState() =>
      _AddLocationScreenState();
}

class _AddLocationScreenState
    extends State<AddLocationScreen> {

  final TextEditingController
  _nameController =
  TextEditingController();

  final TextEditingController
  _latController =
  TextEditingController();

  final TextEditingController
  _lngController =
  TextEditingController();

  String selectedCategory =
      'academic';

  bool isLoading = false;

  // 🚀 SAVE LOCATION
  Future<void> _saveLocation()
  async {

    final String name =
    _nameController.text.trim();

    final double? lat =
    double.tryParse(
      _latController.text.trim(),
    );

    final double? lng =
    double.tryParse(
      _lngController.text.trim(),
    );

    if (name.isEmpty ||
        lat == null ||
        lng == null) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "Please fill all fields correctly",
          ),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      // 🔥 SAVE TO FIREBASE
      await FirebaseFirestore
          .instance
          .collection('locations')
          .add({

        'name': name,
        'lat': lat,
        'lng': lng,
        'category':
        selectedCategory,
      });

      // ✅ SUCCESS
      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "Location Added Successfully 😎",
          ),
        ),
      );

      // 🧹 CLEAR FIELDS
      _nameController.clear();

      _latController.clear();

      _lngController.clear();

      setState(() {
        selectedCategory =
        'academic';
      });

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content:
          Text("Error: $e"),
        ),
      );

    } finally {

      setState(() {
        isLoading = false;
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
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
          ),
        ),

        child: SafeArea(

          child: SingleChildScrollView(

            child: SizedBox(

              height:
              MediaQuery.of(context)
                  .size
                  .height,

              child: Padding(

                padding:
                const EdgeInsets.all(
                    25),

                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

                  children: [

                    // 🌟 TITLE
                    const Text(
                      "Add Location",

                      style: TextStyle(

                        color:
                        Colors.white,

                        fontSize: 34,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    const Text(
                      "Add new campus locations",

                      style: TextStyle(
                        color:
                        Colors.white70,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(
                      height: 45,
                    ),

                    // 📍 LOCATION NAME
                    _buildTextField(

                      controller:
                      _nameController,

                      hintText:
                      "Location Name",

                      icon:
                      Icons.location_on,
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    // 🌍 LATITUDE
                    _buildTextField(

                      controller:
                      _latController,

                      hintText:
                      "Latitude",

                      icon:
                      Icons.map,

                      keyboardType:
                      TextInputType.number,
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    // 🌍 LONGITUDE
                    _buildTextField(

                      controller:
                      _lngController,

                      hintText:
                      "Longitude",

                      icon:
                      Icons.map_outlined,

                      keyboardType:
                      TextInputType.number,
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    // 🎯 CATEGORY DROPDOWN
                    Container(

                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),

                      decoration:
                      BoxDecoration(

                        color:
                        Colors.white
                            .withOpacity(
                            0.08),

                        borderRadius:
                        BorderRadius.circular(
                            20),

                        border: Border.all(
                          color:
                          Colors.white
                              .withOpacity(
                              0.2),
                        ),
                      ),

                      child:
                      DropdownButtonHideUnderline(

                        child:
                        DropdownButton<String>(

                          value:
                          selectedCategory,

                          dropdownColor:
                          Colors.black87,

                          style:
                          const TextStyle(
                            color:
                            Colors.white,
                          ),

                          isExpanded: true,

                          items: [

                            'academic',
                            'food',
                            'administration',
                            'shop',
                            'entry',
                            'hostel',
                            'hospital',

                          ].map((category) {

                            return DropdownMenuItem(

                              value:
                              category,

                              child: Text(
                                category,
                              ),
                            );
                          }).toList(),

                          onChanged: (value) {

                            setState(() {

                              selectedCategory =
                              value!;
                            });
                          },
                        ),
                      ),
                    ),

                    const Spacer(),

                    // 🚀 SAVE BUTTON
                    GestureDetector(

                      onTap:
                      isLoading
                          ? null
                          : _saveLocation,

                      child: Container(

                        width:
                        double.infinity,

                        padding:
                        const EdgeInsets.symmetric(
                          vertical: 20,
                        ),

                        decoration:
                        BoxDecoration(

                          borderRadius:
                          BorderRadius.circular(
                              20),

                          gradient:
                          const LinearGradient(

                            colors: [
                              Colors.green,
                              Colors.lightGreen,
                            ],
                          ),

                          boxShadow: [

                            BoxShadow(
                              color: Colors.green
                                  .withOpacity(
                                  0.4),

                              blurRadius: 18,
                              offset:
                              const Offset(
                                  0, 5),
                            ),
                          ],
                        ),

                        child: Center(

                          child:
                          isLoading

                              ? const CircularProgressIndicator(
                            color:
                            Colors.white,
                          )

                              : const Text(

                            "SAVE LOCATION",

                            style: TextStyle(

                              color:
                              Colors.white,

                              fontSize: 20,

                              fontWeight:
                              FontWeight.bold,

                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 90,
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

    TextInputType keyboardType =
        TextInputType.text,

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

        keyboardType: keyboardType,

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