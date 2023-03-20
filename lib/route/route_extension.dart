import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map
    show LatLng;
import 'package:interactive_diary/route/map_route.dart';
import 'package:interactive_diary/route/route_extra.dart';
import 'package:nartus_storage/nartus_storage.dart';

extension RouterExtension on BuildContext {
  /// Add all path to this extension, and keep all GoRouter within this class
  /// example:
  /// void goToLoginPage() {
  ///   GoRouter.of(this).replace('/login');
  /// }
  ///

  void gotoWriteDiaryScreen(map.LatLng latLng, String? address, String? business) {
    GoRouter.of(this).push(writeDiaryRoute,
        extra: WriteDiaryExtra(LatLng(lat: latLng.latitude, long: latLng.longitude), address, business));
  }

  void goToHome() {
    GoRouter.of(this).replace(idHomeRoute);
  }
}
