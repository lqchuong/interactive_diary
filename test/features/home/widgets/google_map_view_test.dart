import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:interactive_diary/features/home/widgets/google_map.dart';

import '../../../widget_tester_extension.dart';

void main() {
  testWidgets(
      'when load GoogleMapView, then show GoogleMap widget inside AnimatedBuilder',
      (WidgetTester widgetTester) async {
    GoogleMapView widget =
        const GoogleMapView(currentLocation: LatLng(0.0, 0.0));

    await widgetTester.wrapAndPump(Directionality(
      textDirection: TextDirection.ltr,
      child: widget,
    ),
    infiniteAnimationWidget: true);

    expect(
        find.descendant(
            of: find.byType(AnimatedBuilder), matching: find.byType(GoogleMap)),
        findsOneWidget);

    GoogleMap map = widgetTester.widget(find.byType(GoogleMap)) as GoogleMap;

    // at this time, there's no marker in the list yet
    expect(map.markers.length, 0);
  });

  group('Test circular menu', () {
    testWidgets(
      'when circular menu is closing, then circular menu items will not be shown on screen',
        (WidgetTester widgetTester) async {
          GoogleMapView widget =
            const GoogleMapView(currentLocation: LatLng(0.0, 0.0));

          await widgetTester.wrapAndPump(Directionality(
            textDirection: TextDirection.ltr,
            child: widget,
          ));

          GoogleMap map = widgetTester.widget(find.byType(GoogleMap)) as GoogleMap;

          bool isShowingMenu = map.markers.contains(const Marker(markerId: MarkerId(menuCameraMarkerLocationId)));
          isShowingMenu = map.markers.contains(const Marker(markerId: MarkerId(menuEmojiMarkerLocationId)));
          isShowingMenu = map.markers.contains(const Marker(markerId: MarkerId(menuVoiceMarkerLocationId)));
          isShowingMenu = map.markers.contains(const Marker(markerId: MarkerId(menuPencilMarkerLocationId)));

          expect(isShowingMenu, false);
      });

    /// Can't simulate tapping on screen to open/ close menu. Because google map view
    /// is native view. And testWidgets is on flutter layer -> Not work
    // testWidgets(
    //   'when circular menu is opening, then circular menu items will be shown on screen',
    //       (WidgetTester widgetTester) async {
    //     final GlobalKey mapKey = GlobalKey();
    //     GoogleMapView widget = GoogleMapView(currentLocation: const LatLng(0.0, 0.0), key: mapKey,);
    //
    //     await widgetTester.wrapAndPump(Directionality(
    //       textDirection: TextDirection.ltr,
    //       child: widget,
    //     ));
    //
    //     GoogleMap map = widgetTester.widget(find.byType(GoogleMap)) as GoogleMap;
    //     await widgetTester.tapAt(const Offset(0.5, 1.0));
    //     await widgetTester.pumpAndSettle();
    //
    //     bool isShowingMenu = map.markers.contains(const Marker(markerId: MarkerId(menuCameraMarkerLocationId)));
    //     isShowingMenu = map.markers.contains(const Marker(markerId: MarkerId(menuEmojiMarkerLocationId)));
    //     isShowingMenu = map.markers.contains(const Marker(markerId: MarkerId(menuVoiceMarkerLocationId)));
    //     isShowingMenu = map.markers.contains(const Marker(markerId: MarkerId(menuPencilMarkerLocationId)));
    //
    //     expect(isShowingMenu, true);
    //   });
  });
}
