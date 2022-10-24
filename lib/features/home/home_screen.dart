import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:interactive_diary/constants/dimens.dart';
import 'package:nartus_ui_package/nartus_ui.dart';
import 'package:interactive_diary/bloc/location/location_bloc.dart';
import 'package:interactive_diary/generated/l10n.dart';
import 'dart:ui' as ui;

class IDHome extends StatefulWidget {
  const IDHome({
    Key? key,
  }) : super(key: key);

  @override
  State<IDHome> createState() => _IDHomeState();
}

class _IDHomeState extends State<IDHome> with WidgetsBindingObserver {
  bool isAnimation = false;
  late Future<List<Marker>> futureListMarker;

  Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        ?.buffer
        .asUint8List();
  }

  Future<List<Marker>> generateListMarkers(
      double latitude, double longitude) async {
    List<Marker> markers = <Marker>[];
    final Uint8List? markerIconClose =
        await getBytesFromAsset('assets/images/marker_nonetap.png', 120);
    final Uint8List? markerIconOpen =
        await getBytesFromAsset('assets/images/marker_ontap.png', 120);
    final BitmapDescriptor icon = isAnimation == true
        ? BitmapDescriptor.fromBytes(markerIconClose!)
        : BitmapDescriptor.fromBytes(markerIconOpen!);

    final Marker marker = Marker(
        markerId: MarkerId(latitude.toString()),
        position: LatLng(latitude, longitude),
        icon: icon,
        anchor: const Offset(0.5, 0.7),
        onTap: () {
          setState(() {
            isAnimation = !isAnimation;
          });
        });

    markers.add(marker);
    return markers;
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<LocationBloc, LocationState>(
        builder: (BuildContext context, LocationState state) {
          if (state is LocationReadyState) {
            futureListMarker = generateListMarkers(
                state.currentLocation.latitude,
                state.currentLocation.longitude);

            return Stack(
              children: <Widget>[
                FutureBuilder<List<Marker>>(
                    future: futureListMarker,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Marker>> snapshot) {
                      if (snapshot.hasData) {
                        return GoogleMap(
                            initialCameraPosition: CameraPosition(
                                target: LatLng(state.currentLocation.latitude,
                                    state.currentLocation.longitude),
                                zoom: 15),
                            markers: Set<Marker>.of(
                                snapshot.data as Iterable<Marker>));
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
                SafeArea(
                    child: Align(
                  alignment: Alignment.topCenter,
                  child: Card(
                    margin: const EdgeInsets.only(top: Dimension.spacing16),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Dimension.spacing16)),
                    elevation: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimension.spacing16,
                          vertical: Dimension.spacing8),
                      child: Text(
                        state.dateDisplay,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ))
              ],
            );
          }

          if (state is LocationInitial) {
            context.read<LocationBloc>().add(RequestCurrentLocationEvent());
          }

          if (state is LocationPermissionDeniedState) {
            context.showDialogAdaptive(
                title: Text(S.of(context).locationPermissionDialogTitle),
                content: Text(S.of(context).locationPermissionDialogMessage),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        debugPrint('show dialog');
                        context
                            .read<LocationBloc>()
                            .add(ShowDialogRequestPermissionEvent());

                        Navigator.of(context).pop();
                      },
                      child: Text(
                          S.of(context).locationPermissionDialogAllowButton)),
                  TextButton(
                      onPressed: () {
                        debugPrint('click continue button');
                        Navigator.of(context).pop();
                        context
                            .read<LocationBloc>()
                            .add(RequestDefaultLocationEvent());
                      },
                      child: Text(S
                          .of(context)
                          .locationPermissionDialogContinueButton)),
                ]);
          }

          if (state is LocationPermissionDeniedForeverState) {
            context.showDialogAdaptive(
                title: Text(S.of(context).locationPermissionDialogTitle),
                content: Text(S.of(context).locationPermissionDialogMessage),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        debugPrint('show dialog');
                        context
                            .read<LocationBloc>()
                            .add(OpenAppSettingsEvent());

                        Navigator.of(context).pop();
                      },
                      child: Text(S
                          .of(context)
                          .locationPermissionDialogOpenSettingsButton)),
                  TextButton(
                      onPressed: () {
                        debugPrint('click continue button');
                        Navigator.of(context).pop();
                        context
                            .read<LocationBloc>()
                            .add(RequestDefaultLocationEvent());
                      },
                      child: Text(S
                          .of(context)
                          .locationPermissionDialogContinueButton)),
                ]);
          }

          if (state is AwaitLocationPermissionFromAppSettingState) {
            WidgetsBinding.instance.addObserver(this);
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      WidgetsBinding.instance.removeObserver(this);
      context.read<LocationBloc>().add(ReturnedFromAppSettingsEvent());
    }
  }
}
