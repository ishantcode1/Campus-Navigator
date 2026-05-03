import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewLocationsScreen
    extends StatelessWidget {

  const ViewLocationsScreen({
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
            const EdgeInsets.all(
                20),

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment
                  .start,

              children: [

                // 🌟 TITLE
                const Text(
                  "All Locations",

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
                  "View all campus locations",

                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                // 🔥 FIREBASE LIST
                Expanded(

                  child:
                  StreamBuilder(

                    stream:
                    FirebaseFirestore
                        .instance
                        .collection(
                        'locations')
                        .snapshots(),

                    builder:
                        (
                        context,
                        snapshot,
                        ) {

                      // ⏳ LOADING
                      if (snapshot
                          .connectionState ==
                          ConnectionState
                              .waiting) {

                        return const Center(

                          child:
                          CircularProgressIndicator(
                            color:
                            Colors.green,
                          ),
                        );
                      }

                      // ❌ ERROR
                      if (snapshot
                          .hasError) {

                        return const Center(

                          child: Text(
                            "Something went wrong",

                            style: TextStyle(
                              color:
                              Colors.white,
                            ),
                          ),
                        );
                      }

                      // 📭 EMPTY
                      if (!snapshot
                          .hasData ||
                          snapshot
                              .data!
                              .docs
                              .isEmpty) {

                        return const Center(

                          child: Text(
                            "No Locations Found",

                            style: TextStyle(
                              color:
                              Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        );
                      }

                      final locations =
                          snapshot
                              .data!
                              .docs;

                      return ListView.builder(

                        itemCount:
                        locations
                            .length,

                        itemBuilder:
                            (
                            context,
                            index,
                            ) {

                          final location =
                          locations[
                          index]
                              .data();

                          return Container(

                            margin:
                            const EdgeInsets.only(
                                bottom:
                                18),

                            padding:
                            const EdgeInsets.all(
                                20),

                            decoration:
                            BoxDecoration(

                              color: Colors
                                  .white
                                  .withOpacity(
                                  0.08),

                              borderRadius:
                              BorderRadius.circular(
                                  22),

                              border:
                              Border.all(
                                color: Colors
                                    .white
                                    .withOpacity(
                                    0.2),
                              ),

                              boxShadow: [

                                BoxShadow(
                                  color: Colors
                                      .black
                                      .withOpacity(
                                      0.2),

                                  blurRadius:
                                  10,
                                ),
                              ],
                            ),

                            child: Column(

                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                              children: [

                                // 🌟 NAME
                                Text(
                                  location[
                                  'name'],

                                  style:
                                  const TextStyle(

                                    color:
                                    Colors.white,

                                    fontSize:
                                    22,

                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(
                                  height: 12,
                                ),

                                // 📂 CATEGORY
                                Row(

                                  children: [

                                    const Icon(
                                      Icons.category,

                                      color:
                                      Colors.green,
                                    ),

                                    const SizedBox(
                                      width:
                                      8,
                                    ),

                                    Text(
                                      location[
                                      'category'],

                                      style:
                                      const TextStyle(

                                        color:
                                        Colors.white70,

                                        fontSize:
                                        16,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                  height: 10,
                                ),

                                // 🌍 LATITUDE
                                Row(

                                  children: [

                                    const Icon(
                                      Icons.map,

                                      color:
                                      Colors.blue,
                                    ),

                                    const SizedBox(
                                      width:
                                      8,
                                    ),

                                    Expanded(

                                      child:
                                      Text(

                                        "Lat: ${location['lat']}",

                                        style:
                                        const TextStyle(

                                          color:
                                          Colors.white70,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                  height: 8,
                                ),

                                // 🌍 LONGITUDE
                                Row(

                                  children: [

                                    const Icon(
                                      Icons.map_outlined,

                                      color:
                                      Colors.orange,
                                    ),

                                    const SizedBox(
                                      width:
                                      8,
                                    ),

                                    Expanded(

                                      child:
                                      Text(

                                        "Lng: ${location['lng']}",

                                        style:
                                        const TextStyle(

                                          color:
                                          Colors.white70,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
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