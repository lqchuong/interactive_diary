part of 'location_bloc.dart';

abstract class LocationState extends Equatable {
  @override
  List<Object?> get props => <Object?>[];
}

class LocationInitial extends LocationState {
  final PermissionStatusDiary status;
  LocationInitial(this.status);

  @override
  List<PermissionStatusDiary> get props => <PermissionStatusDiary>[status];
}

class LocationServiceDisableState extends LocationState {}

class LocationPermissionDeniedState extends LocationState {}

class LocationPermissionDeniedForeverState extends LocationState {}

class AwaitLocationPermissionFromAppSettingState extends LocationState {}

class AwaitLocationServiceSettingState extends LocationState {}

class UnknownLocationErrorState extends LocationState {}

class LocationReadyState extends LocationState {
  final LatLng currentLocation;
  final String? address;
  final String? countryCode;
  final String? postalCode;
  final String? business;
  final String dateDisplay;

  LocationReadyState(
  {required this.currentLocation, required this.dateDisplay, required this.address,required  this.business, required this.countryCode,required  this.postalCode});

  @override
  List<Object?> get props => [
        currentLocation.latitude,
        currentLocation.longitude,
        address,
        business,
        dateDisplay,
    countryCode,
    postalCode
      ];
}
