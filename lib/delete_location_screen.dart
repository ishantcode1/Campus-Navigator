import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteLocationScreen
    extends StatelessWidget {

  const DeleteLocationScreen({
    super.key,
  });

  // 🗑 DELETE FUNCTION
  Future<void> _deleteLocation(
      BuildContext context,
      String docId,
      ) async {

    try {

      await FirebaseFirestore
          .instance
          .collection('locations')
          .doc(docId)
          .delete();

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "Location Deleted 😎",
          ),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content:
          Text("Error: $e"),
        ),
      );
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
                  "Delete Locations",

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
                  "Remove campus locations",

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
                            Colors.red,
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

                          final locationDoc =
                          locations[
                          index];

                          final location =
                          locationDoc
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

                            child: Row(

                              children: [

                                // 🌟 LOCATION INFO
                                Expanded(

                                  child: Column(

                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                    children: [

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
                                        height:
                                        8,
                                      ),

                                      Text(
                                        location[
                                        'category'],

                                        style:
                                        const TextStyle(

                                          color:
                                          Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // 🗑 DELETE BUTTON
                                GestureDetector(

                                  onTap: () {

                                    showDialog(

                                      context:
                                      context,

                                      builder:
                                          (
                                          context,
                                          ) {

                                        return AlertDialog(

                                          backgroundColor:
                                          Colors.black87,

                                          title:
                                          const Text(

                                            "Delete Location",

                                            style:
                                            TextStyle(
                                              color:
                                              Colors.white,
                                            ),
                                          ),

                                          content:
                                          Text(

                                            "Delete ${location['name']} ?",

                                            style:
                                            const TextStyle(
                                              color:
                                              Colors.white70,
                                            ),
                                          ),

                                          actions: [

                                            TextButton(

                                              onPressed:
                                                  () {

                                                Navigator.pop(
                                                    context);
                                              },

                                              child:
                                              const Text(
                                                "Cancel",
                                              ),
                                            ),

                                            TextButton(

                                              onPressed:
                                                  () async {

                                                Navigator.pop(
                                                    context);

                                                await _deleteLocation(

                                                  context,

                                                  locationDoc.id,
                                                );
                                              },

                                              child:
                                              const Text(

                                                "Delete",

                                                style:
                                                TextStyle(
                                                  color:
                                                  Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },

                                  child: Container(

                                    padding:
                                    const EdgeInsets.all(
                                        12),

                                    decoration:
                                    BoxDecoration(

                                      color: Colors
                                          .red
                                          .withOpacity(
                                          0.2),

                                      shape:
                                      BoxShape.circle,
                                    ),

                                    child:
                                    const Icon(

                                      Icons.delete,

                                      color:
                                      Colors.red,

                                      size: 30,
                                    ),
                                  ),
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