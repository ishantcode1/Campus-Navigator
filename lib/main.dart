import 'splash_screen.dart';
import 'role_selection_screen.dart';
import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const CampusNavigatorApp());
}

class CampusNavigatorApp extends StatelessWidget {
  const CampusNavigatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
      ),

      home: const SplashScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() =>
      _MapScreenState();
}

class _MapScreenState
    extends State<MapScreen> {

  final MapController _mapController =
  MapController();

  // 🔍 Search
  final TextEditingController
  _searchController =
  TextEditingController();

  List<Map<String, dynamic>>
  _locations = [];

  List<Map<String, dynamic>>
  _filteredLocations = [];

  // 📋 Selected location
  Map<String, dynamic>?
  _selectedLocation;

  // 🎯 Selected category
  String _selectedCategory = 'all';

  // 📍 User location
  LatLng? _currentLocation;

  double _zoom = 15;

  // 🔥 Markers
  List<Marker> _markers = [];

  // 🧭 Route points
  List<LatLng> _routePoints = [];

  @override
  void initState() {
    super.initState();

    _getLocation();
    _loadLocations();
  }

  // 📍 Get user GPS location
  Future<void> _getLocation() async {

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled =
    await Geolocator
        .isLocationServiceEnabled();

    if (!serviceEnabled) return;

    permission =
    await Geolocator.checkPermission();

    if (permission ==
        LocationPermission.denied) {

      permission =
      await Geolocator
          .requestPermission();
    }

    Position position =
    await Geolocator
        .getCurrentPosition();

    setState(() {

      _currentLocation = LatLng(
        position.latitude,
        position.longitude,
      );
    });

    _mapController.move(
      _currentLocation!,
      _zoom,
    );
  }

  // 🧭 ROUTING
  Future<void> _getRoute(
      double destinationLat,
      double destinationLng,
      ) async {

    if (_currentLocation == null) {
      return;
    }

    final url = Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/'
          '${_currentLocation!.longitude},${_currentLocation!.latitude};'
          '$destinationLng,$destinationLat'
          '?overview=full&geometries=geojson',
    );

    final response =
    await http.get(url);

    if (response.statusCode == 200) {

      final data =
      jsonDecode(response.body);

      final coordinates =
      data['routes'][0]
      ['geometry']
      ['coordinates'];

      List<LatLng> route = [];

      for (var point
      in coordinates) {

        route.add(
          LatLng(
            point[1],
            point[0],
          ),
        );
      }

      setState(() {
        _routePoints = route;
      });

    } else {

      print(
        'OSRM Route Error',
      );
    }
  }

  // 🔥 LOAD FIREBASE LOCATIONS
  Future<void> _loadLocations()
  async {

    final snapshot =
    await FirebaseFirestore
        .instance
        .collection(
        'locations')
        .get();

    List<Marker> tempMarkers = [];

    List<Map<String, dynamic>>
    tempLocations = [];

    for (var doc
    in snapshot.docs) {

      final data = doc.data();

      final double lat =
      (data['lat'] as num)
          .toDouble();

      final double lng =
      (data['lng'] as num)
          .toDouble();

      final String name =
      data['name'];

      final String category =
      data['category'];

      // 🎯 FILTER
      if (_selectedCategory !=
          'all' &&
          category !=
              _selectedCategory) {
        continue;
      }

      tempLocations.add({
        'name': name,
        'lat': lat,
        'lng': lng,
        'category': category,
      });

      // 🎯 CATEGORY ICONS
      IconData markerIcon =
      category == 'food'
          ? Icons.restaurant

          : category ==
          'academic'
          ? Icons.school

          : category ==
          'administration'
          ? Icons.business

          : category ==
          'shop'
          ? Icons.store

          : category ==
          'entry'
          ? Icons.login

          : category ==
          'hostel'
          ? Icons.hotel

          : category ==
          'hospital'
          ? Icons.local_hospital

          : Icons.location_on;

      // 📍 MARKERS
      tempMarkers.add(
        Marker(
          point:
          LatLng(lat, lng),

          width: 70,
          height: 70,

          child:
          GestureDetector(
            onTap: () async {

              _mapController.move(
                LatLng(
                    lat, lng),
                18,
              );

              await _getRoute(
                lat,
                lng,
              );

              setState(() {

                _selectedLocation =
                {
                  'name': name,
                  'category':
                  category,
                };
              });
            },

            child: Tooltip(
              message: name,

              child:
              AnimatedContainer(
                duration:
                const Duration(
                  milliseconds:
                  300,
                ),

                child: Icon(
                  markerIcon,

                  color:
                  _selectedLocation !=
                      null &&
                      _selectedLocation![
                      'name'] ==
                          name
                      ? Colors.green
                      : Colors.red,

                  size:
                  _selectedLocation !=
                      null &&
                      _selectedLocation![
                      'name'] ==
                          name
                      ? 60
                      : 40,
                ),
              ),
            ),
          ),
        ),
      );
    }

    setState(() {

      _markers = tempMarkers;

      _locations =
          tempLocations;

      _filteredLocations =
          tempLocations;
    });
  }

  // 🔍 SEARCH
  void _searchLocation(
      String query) {

    setState(() {

      _filteredLocations =
          _locations
              .where(
                (location) =>
                location[
                'name']
                    .toLowerCase()
                    .contains(
                  query
                      .toLowerCase(),
                ),
          )
              .toList();
    });
  }

  // 🎯 FILTER BUTTON
  Widget _buildFilterButton(
      String label,
      String category,
      ) {

    final bool isSelected =
        _selectedCategory ==
            category;

    return Padding(
      padding:
      const EdgeInsets.only(
        right: 10,
      ),

      child: GestureDetector(
        onTap: () {

          setState(() {

            _selectedCategory =
                category;
          });

          _loadLocations();
        },

        child:
        AnimatedContainer(
          duration:
          const Duration(
            milliseconds: 300,
          ),

          padding:
          const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 10,
          ),

          decoration:
          BoxDecoration(

            borderRadius:
            BorderRadius.circular(
                30),

            color: isSelected
                ? Colors.green
                : Colors.black
                .withOpacity(
                0.7),

            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withOpacity(
                    0.2),

                blurRadius: 8,
              ),
            ],
          ),

          child: Text(
            label,

            style: TextStyle(
              color:
              Colors.white,

              fontWeight:
              isSelected
                  ? FontWeight
                  .bold
                  : FontWeight
                  .normal,
            ),
          ),
        ),
      ),
    );
  }

  // ➕ ZOOM IN
  void _zoomIn() {

    _zoom += 1;

    _mapController.move(
      _mapController
          .camera.center,
      _zoom,
    );
  }

  // ➖ ZOOM OUT
  void _zoomOut() {

    _zoom -= 1;

    _mapController.move(
      _mapController
          .camera.center,
      _zoom,
    );
  }

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(

      // 🌟 PREMIUM APPBAR
      appBar: AppBar(

        backgroundColor:
        Colors.black,

        elevation: 0,

        centerTitle: true,

        title: const Text(
          "Campus Navigator",

          style: TextStyle(
            fontSize: 24,
            fontWeight:
            FontWeight.bold,
            letterSpacing: 1,
            color: Colors.white,
          ),
        ),
      ),

      body: Stack(
        children: [

          // 🌍 MAP
          FlutterMap(
            mapController:
            _mapController,

            options:
            const MapOptions(
              initialCenter:
              LatLng(
                30.3165,
                78.0322,
              ),

              initialZoom: 15,
            ),

            children: [

              // 🌍 MAP TILES
              TileLayer(
                urlTemplate:
                'https://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}',

                userAgentPackageName:
                'com.example.campus_navigator',
              ),

              // 🧭 ROUTE LINE
              PolylineLayer(
                polylines: [

                  Polyline(
                    points:
                    _routePoints,

                    strokeWidth: 5,

                    color:
                    Colors.blue,
                  ),
                ],
              ),

              // 📍 CLUSTER MARKERS
              MarkerClusterLayerWidget(

                options:
                MarkerClusterLayerOptions(

                  maxClusterRadius:
                  45,

                  size:
                  const Size(
                    40,
                    40,
                  ),

                  markers: [

                    ..._markers,

                    // 🔵 USER LOCATION
                    if (_currentLocation !=
                        null)

                      Marker(
                        point:
                        _currentLocation!,

                        width: 50,
                        height: 50,

                        child:
                        const Icon(
                          Icons
                              .my_location,

                          size: 40,

                          color:
                          Colors.blue,
                        ),
                      ),
                  ],

                  builder:
                      (
                      context,
                      markers,
                      ) {

                    return Container(

                      decoration:
                      const BoxDecoration(

                        color:
                        Colors.green,

                        shape:
                        BoxShape.circle,
                      ),

                      child: Center(

                        child: Text(
                          markers.length
                              .toString(),

                          style:
                          const TextStyle(
                            color:
                            Colors.white,

                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // 🔍 SEARCH
          Positioned(
            top: 20,
            left: 15,
            right: 15,

            child: Column(
              children: [

                // 🌟 PREMIUM SEARCH
                Container(
                  decoration:
                  BoxDecoration(

                    borderRadius:
                    BorderRadius.circular(
                        20),

                    color:
                    Colors.black
                        .withOpacity(
                        0.7),

                    boxShadow: [

                      BoxShadow(
                        color: Colors
                            .black
                            .withOpacity(
                            0.3),

                        blurRadius:
                        10,

                        offset:
                        const Offset(
                            0, 5),
                      ),
                    ],
                  ),

                  child: TextField(
                    controller:
                    _searchController,

                    onChanged:
                    _searchLocation,

                    style:
                    const TextStyle(
                      color:
                      Colors.white,
                    ),

                    decoration:
                    InputDecoration(

                      hintText:
                      'Search locations...',

                      hintStyle:
                      const TextStyle(
                        color:
                        Colors.white70,
                      ),

                      prefixIcon:
                      const Icon(
                        Icons.search,
                        color:
                        Colors.white,
                      ),

                      filled: true,

                      fillColor:
                      Colors.transparent,

                      border:
                      OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(
                            20),

                        borderSide:
                        BorderSide.none,
                      ),
                    ),
                  ),
                ),

                // 🔍 SEARCH RESULTS
                if (_searchController
                    .text
                    .isNotEmpty)

                  Container(

                    margin:
                    const EdgeInsets.only(
                        top: 8),

                    decoration:
                    BoxDecoration(

                      color:
                      Colors.black
                          .withOpacity(
                          0.8),

                      borderRadius:
                      BorderRadius.circular(
                          15),
                    ),

                    child:
                    ListView.builder(

                      shrinkWrap:
                      true,

                      itemCount:
                      _filteredLocations
                          .length,

                      itemBuilder:
                          (
                          context,
                          index,
                          ) {

                        final location =
                        _filteredLocations[
                        index];

                        return ListTile(

                          title: Text(
                            location[
                            'name'],

                            style:
                            const TextStyle(
                              color:
                              Colors.white,
                            ),
                          ),

                          subtitle:
                          Text(
                            location[
                            'category'],

                            style:
                            const TextStyle(
                              color:
                              Colors.white70,
                            ),
                          ),

                          onTap:
                              () async {

                            final lat =
                            location[
                            'lat'];

                            final lng =
                            location[
                            'lng'];

                            _mapController
                                .move(
                              LatLng(
                                  lat,
                                  lng),
                              18,
                            );

                            await _getRoute(
                              lat,
                              lng,
                            );

                            setState(() {

                              _selectedLocation =
                                  location;

                              _searchController
                                  .clear();

                              _filteredLocations =
                              [];
                            });

                            _loadLocations();
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),

          // 🎯 FILTERS
          if (_searchController
              .text
              .isEmpty)

            Positioned(
              top: 80,
              left: 10,
              right: 10,

              child:
              SingleChildScrollView(

                scrollDirection:
                Axis.horizontal,

                child: Row(
                  children: [

                    _buildFilterButton(
                      'All',
                      'all',
                    ),

                    _buildFilterButton(
                      'Food',
                      'food',
                    ),

                    _buildFilterButton(
                      'Academic',
                      'academic',
                    ),

                    _buildFilterButton(
                      'Admin',
                      'administration',
                    ),

                    _buildFilterButton(
                      'Entry',
                      'entry',
                    ),

                    _buildFilterButton(
                      'Shop',
                      'shop',
                    ),

                    _buildFilterButton(
                      'Hostel',
                      'hostel',
                    ),

                    _buildFilterButton(
                      'Hospital',
                      'hospital',
                    ),
                  ],
                ),
              ),
            ),

          // 📋 INFO CARD
          if (_selectedLocation !=
              null)

            Positioned(
              left: 15,
              right: 15,
              bottom: 90,

              child: Container(

                decoration:
                BoxDecoration(

                  borderRadius:
                  BorderRadius.circular(
                      25),

                  gradient:
                  const LinearGradient(

                    colors: [
                      Colors.black87,
                      Colors.black54,
                    ],
                  ),

                  boxShadow: [

                    BoxShadow(
                      color:
                      Colors.black
                          .withOpacity(
                          0.3),

                      blurRadius:
                      12,

                      offset:
                      const Offset(
                          0, 5),
                    ),
                  ],
                ),

                child: Padding(
                  padding:
                  const EdgeInsets.all(
                      20),

                  child: Column(

                    mainAxisSize:
                    MainAxisSize
                        .min,

                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                    children: [

                      Row(
                        children: [

                          const Icon(
                            Icons.location_on,
                            color:
                            Colors.green,
                            size: 28,
                          ),

                          const SizedBox(
                            width: 10,
                          ),

                          Expanded(

                            child: Text(
                              _selectedLocation![
                              'name'],

                              style:
                              const TextStyle(

                                fontSize: 22,

                                fontWeight:
                                FontWeight.bold,

                                color:
                                Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      Text(
                        "Category: ${_selectedLocation!['category']}",

                        style:
                        const TextStyle(
                          fontSize: 16,
                          color:
                          Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // 🔍 ZOOM BUTTONS
          Positioned(
            right: 15,
            bottom: 20,

            child: Column(
              children: [

                Container(
                  decoration:
                  BoxDecoration(

                    color:
                    Colors.black
                        .withOpacity(
                        0.7),

                    borderRadius:
                    BorderRadius.circular(
                        15),
                  ),

                  child: IconButton(

                    onPressed:
                    _zoomIn,

                    icon:
                    const Icon(
                      Icons.add,
                      color:
                      Colors.white,
                    ),
                  ),
                ),

                const SizedBox(
                    height: 10),

                Container(
                  decoration:
                  BoxDecoration(

                    color:
                    Colors.black
                        .withOpacity(
                        0.7),

                    borderRadius:
                    BorderRadius.circular(
                        15),
                  ),

                  child: IconButton(

                    onPressed:
                    _zoomOut,

                    icon:
                    const Icon(
                      Icons.remove,
                      color:
                      Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}