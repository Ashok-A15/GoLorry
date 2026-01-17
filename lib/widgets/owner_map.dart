import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OwnerMap extends StatefulWidget {
  const OwnerMap({super.key});

  @override
  State<OwnerMap> createState() => _OwnerMapState();
}

class _OwnerMapState extends State<OwnerMap> {
  final Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor laariIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    setCustomMarker();
  }

  void setCustomMarker() async {
    BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(24, 24)),
      "assets/laari.png",
    );
    setState(() => laariIcon = icon);
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = {
      Marker(
        markerId: const MarkerId("laari1"),
        position: const LatLng(12.3077, 76.6533),
        icon: laariIcon,
      ),
      Marker(
        markerId: const MarkerId("laari2"),
        position: const LatLng(12.3100, 76.6400),
        icon: laariIcon,
      ),
      Marker(
        markerId: const MarkerId("laari3"),
        position: const LatLng(12.3000, 76.6600),
        icon: laariIcon,
      ),
    };

    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(12.3077, 76.6533),
        zoom: 13,
      ),
      markers: markers,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }
}
