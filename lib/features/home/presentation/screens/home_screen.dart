import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/constants/route_constants.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  GoogleMapController? _mapController;
  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(9.0820, 8.6753), // Nigeria's coordinates
    zoom: 14.0,
  );
  
  Set<Marker> _markers = {};
  bool _isLoading = true;
  bool _isBottomSheetExpanded = false;
  
  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }
  
  Future<void> _loadInitialData() async {
    // Simulate loading data
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() {
        _isLoading = false;
        // Add sample markers
        _markers = {
          const Marker(
            markerId: MarkerId('current_location'),
            position: LatLng(9.0820, 8.6753),
            infoWindow: InfoWindow(title: 'Your Location'),
          ),
          const Marker(
            markerId: MarkerId('driver_1'),
            position: LatLng(9.0840, 8.6780),
            infoWindow: InfoWindow(title: 'Available Driver'),
          ),
          const Marker(
            markerId: MarkerId('driver_2'),
            position: LatLng(9.0800, 8.6730),
            infoWindow: InfoWindow(title: 'Available Driver'),
          ),
        };
      });
    }
  }
  
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }
  
  void _toggleBottomSheet() {
    setState(() {
      _isBottomSheetExpanded = !_isBottomSheetExpanded;
    });
  }
  
  void _requestRide() {
    context.go('${RouteConstants.home}/ride');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            markers: _markers,
          ),
          
          // Loading indicator
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          
          // App bar
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    child: IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        // TODO: Open drawer
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Where to?',
                          prefixIcon: const Icon(Icons.search),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.star_border),
                            onPressed: () {
                              // TODO: Show saved locations
                            },
                          ),
                        ),
                        onTap: () {
                          // TODO: Open destination search screen
                        },
                        readOnly: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _isBottomSheetExpanded ? 300 : 120,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Handle
                  GestureDetector(
                    onTap: _toggleBottomSheet,
                    child: Container(
                      width: 50,
                      height: 5,
                      margin: const EdgeInsets.only(top: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Book a ride',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_isBottomSheetExpanded) ...[
                          // Ride options
                          _buildRideOption(
                            icon: Icons.directions_car,
                            title: 'Standard',
                            subtitle: '4 seats • 5 min away',
                            price: '₦1,200',
                            isSelected: true,
                          ),
                          const SizedBox(height: 12),
                          _buildRideOption(
                            icon: Icons.local_taxi,
                            title: 'Comfort',
                            subtitle: '4 seats • 8 min away',
                            price: '₦1,800',
                            isSelected: false,
                          ),
                          const SizedBox(height: 12),
                          _buildRideOption(
                            icon: Icons.airport_shuttle,
                            title: 'XL',
                            subtitle: '6 seats • 10 min away',
                            price: '₦2,500',
                            isSelected: false,
                          ),
                        ],
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _requestRide,
                          child: const Text('Request Ride'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // My location button
          Positioned(
            bottom: _isBottomSheetExpanded ? 320 : 140,
            right: 16,
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: IconButton(
                icon: const Icon(Icons.my_location),
                onPressed: () {
                  _mapController?.animateCamera(
                    CameraUpdate.newCameraPosition(_initialCameraPosition),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRideOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required String price,
    required bool isSelected,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 32,
            color: isSelected ? Theme.of(context).colorScheme.primary : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Theme.of(context).colorScheme.primary : null,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
        ],
      ),
    );
  }
}
