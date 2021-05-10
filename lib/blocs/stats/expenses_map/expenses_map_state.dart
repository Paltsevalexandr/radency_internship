part of 'expenses_map_bloc.dart';

class ExpensesMapState extends Equatable {
  ExpensesMapState({
    this.sliderCurrentTimeIntervalString = '',
    this.isFocusing = false,
    this.shouldAnimateToPosition = false,
    this.animateTargetPosition,
    this.initialCameraPosition,
    this.isMapInitialized = false,
    this.markers,
  });

  final bool isMapInitialized;
  final bool isFocusing;
  final String sliderCurrentTimeIntervalString;
  final bool shouldAnimateToPosition;
  final LatLng animateTargetPosition;
  final CameraPosition initialCameraPosition;
  final Set<Marker> markers;

  @override
  List<Object> get props => [sliderCurrentTimeIntervalString, isFocusing, animateTargetPosition, initialCameraPosition, markers];

  ExpensesMapState initial({@required CameraPosition cameraPosition}) {
    return copyWith(initialCameraPosition: cameraPosition, isMapInitialized: true, markers: <Marker>{});
  }

  ExpensesMapState setFocusing() {
    return copyWith(isFocusing: true);
  }

  ExpensesMapState setFocused() {
    return copyWith(isFocusing: false);
  }

  ExpensesMapState animateToPosition({@required LatLng latLng}) {
    return copyWith(animateTargetPosition: latLng, shouldAnimateToPosition: true);
  }

  ExpensesMapState setSliderTitle({@required String sliderCurrentTimeIntervalString, bool clearMarkers}) {
    return copyWith(sliderCurrentTimeIntervalString: sliderCurrentTimeIntervalString, markers: <Marker>{});
  }

  ExpensesMapState showMarkers({@required Set<Marker> markers}) {
    return copyWith(markers: markers);
  }

  ExpensesMapState clearMarkers() {
    return copyWith(markers: <Marker>{});
  }


  ExpensesMapState copyWith({
    bool isMapInitialized,
    CameraPosition initialCameraPosition,
    bool isFocusing,
    bool shouldAnimateToPosition,
    LatLng animateTargetPosition,
    String sliderCurrentTimeIntervalString,
    Set<Marker> markers,
  }) {
    return ExpensesMapState(
        sliderCurrentTimeIntervalString: sliderCurrentTimeIntervalString ?? this.sliderCurrentTimeIntervalString,
        initialCameraPosition: initialCameraPosition ?? this.initialCameraPosition,
        isFocusing: isFocusing ?? this.isFocusing,
        isMapInitialized: isMapInitialized ?? this.isMapInitialized,
        shouldAnimateToPosition: shouldAnimateToPosition ?? false,
        animateTargetPosition: animateTargetPosition ?? null,
        markers: markers ?? this.markers);
  }
}
