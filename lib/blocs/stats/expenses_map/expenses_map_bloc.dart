import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:radency_internship_project_2/blocs/settings/settings_bloc.dart';
import 'package:radency_internship_project_2/models/expense_item.dart';
import 'package:radency_internship_project_2/utils/date_formatters.dart';
import 'package:radency_internship_project_2/utils/geolocator_utils.dart';
import 'package:radency_internship_project_2/utils/mocked_expenses.dart';

part 'expenses_map_event.dart';

part 'expenses_map_state.dart';

class ExpensesMapBloc extends Bloc<ExpensesMapEvent, ExpensesMapState> {
  ExpensesMapBloc({@required this.settingsBloc}) : super(ExpensesMapState());

  SettingsBloc settingsBloc;
  StreamSubscription settingsSubscription;
  String locale = '';

  DateTime _observedDate;
  String _sliderCurrentTimeIntervalString = '';
  StreamSubscription expenseMapTimeIntervalSubscription;
  ClusterManager<ExpenseItemEntity> _manager;

  @override
  Future<void> close() {
    expenseMapTimeIntervalSubscription?.cancel();
    settingsSubscription?.cancel();
    return super.close();
  }

  final CameraPosition _defaultCameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Stream<ExpensesMapState> mapEventToState(
    ExpensesMapEvent event,
  ) async* {
    if (event is ExpensesMapInitialize) {
      yield* _mapExpensesMapInitializeToState();
    } else if (event is ExpensesMapCurrentLocationPressed) {
      yield* _mapExpensesMapCurrentLocationPressedToState();
    } else if (event is ExpensesMapSliderBackPressed) {
      yield* _mapExpensesMapSliderBackPressedToState();
    } else if (event is ExpensesMapSliderForwardPressed) {
      yield* _mapExpensesMapSliderForwardPressedToState();
    } else if (event is ExpensesMapFetchRequested) {
      yield* _mapTransactionsDailyFetchRequestedToState(dateForFetch: event.dateForFetch);
    } else if (event is ExpensesMapDisplayRequested) {
      yield* _mapTransactionDailyDisplayRequestedToState(event.expenseData);
    } else if (event is ExpensesMapOnCameraMoved) {
      _manager.onCameraMove(event.cameraPosition);
    } else if (event is ExpensesMapOnCameraMoveEnded) {
      _manager.updateMap();
    } else if (event is ExpensesMapCreated) {
      _manager.setMapController(event.controller);
    } else if (event is ExpensesMapMarkersUpdated) {
      yield state.showMarkers(markers: event.markers);
    } else if (event is ExpensesMapLocaleChanged) {
      yield* _mapExpensesMapLocaleChangedToState();
    }
  }

  Stream<ExpensesMapState> _mapExpensesMapInitializeToState() async* {
    yield state.initial(cameraPosition: _defaultCameraPosition);

    _observedDate = DateTime.now();

    if (settingsBloc.state is LoadedSettingsState) {
      locale = settingsBloc.state.language;
    }
    settingsBloc.stream.listen((newSettingsState) {
      print("TransactionsDailyBloc._mapTransactionsDailyInitializeToState: newSettingsState");
      if (newSettingsState is LoadedSettingsState && newSettingsState.language != locale) {
        locale = newSettingsState.language;
        add(ExpensesMapLocaleChanged());
      }
    });

    _manager = ClusterManager<ExpenseItemEntity>(
      [ClusterItem(LatLng(37.42796133580664, -122.085749655962))],
      _updateMarkers,
      markerBuilder: _markerBuilder,
      initialZoom: 14.4746,
      levels: [1, 4.25, 6.75, 8.25, 11.5, 14.5, 16.0, 16.5, 20.0],
    );

    add(ExpensesMapFetchRequested(dateForFetch: _observedDate));
    //add(ExpensesMapCurrentLocationPressed());
  }

  Stream<ExpensesMapState> _mapExpensesMapLocaleChangedToState() async* {
    _sliderCurrentTimeIntervalString =
        DateFormatters().monthNameAndYearFromDateTimeString(_observedDate, locale: locale);

    print("TransactionsDailyBloc._mapTransactionsDailyLocaleChangedToState: $_sliderCurrentTimeIntervalString");

    yield state.setSliderTitle(sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString);
  }

  Stream<ExpensesMapState> _mapTransactionsDailyFetchRequestedToState({@required DateTime dateForFetch}) async* {
    expenseMapTimeIntervalSubscription?.cancel();

    _sliderCurrentTimeIntervalString = DateFormatters().monthNameAndYearFromDateTimeString(_observedDate);
    yield state.setSliderTitle(sliderCurrentTimeIntervalString: _sliderCurrentTimeIntervalString, clearMarkers: true);
    expenseMapTimeIntervalSubscription = Future.delayed(Duration(seconds: 2)).asStream().listen((event) {
      // TODO: Implement fetch endpoint
      var dailyData = MockedExpensesItems().generateDailyData(
          locationLatitude: _defaultCameraPosition.target.latitude,
          locationLongitude: _defaultCameraPosition.target.longitude);
      add(ExpensesMapDisplayRequested(expenseData: dailyData, data: _sliderCurrentTimeIntervalString));
    });
  }

  Stream<ExpensesMapState> _mapTransactionDailyDisplayRequestedToState(
      Map<int, List<ExpenseItemEntity>> expenseData) async* {
    List<ClusterItem<ExpenseItemEntity>> list = [];

    expenseData.values.forEach((value) {
      value.forEach((element) {
        if (element.type == ExpenseType.outcome) {
          list.add(
              ClusterItem(LatLng(element.expenseLocation.latitude, element.expenseLocation.longitude), item: element));
        }
      });
    });

    _manager.setItems(list);
  }

  Stream<ExpensesMapState> _mapExpensesMapCurrentLocationPressedToState() async* {
    yield state.setFocusing();

    try {
      Position position = await GeolocatorUtils().determinePosition();
      yield state.animateToPosition(latLng: LatLng(position.latitude, position.longitude));
    } catch (e) {
      // TODO: handle errors
    }

    yield state.setFocused();
  }

  Stream<ExpensesMapState> _mapExpensesMapSliderBackPressedToState() async* {
    _observedDate = DateTime(_observedDate.year, _observedDate.month - 1);
    add(ExpensesMapFetchRequested(dateForFetch: _observedDate));
  }

  Stream<ExpensesMapState> _mapExpensesMapSliderForwardPressedToState() async* {
    _observedDate = DateTime(_observedDate.year, _observedDate.month + 1);
    add(ExpensesMapFetchRequested(dateForFetch: _observedDate));
  }

  Future<Marker> Function(Cluster<ExpenseItemEntity>) get _markerBuilder => (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () {
            print('---- $cluster');
            cluster.items.forEach((p) => print(p));
          },
          icon: await _getMarkerBitmap(100, 250, text: _getExpensesClusterSum(cluster).toStringAsFixed(2)),
        );
      };

  Future<BitmapDescriptor> _getMarkerBitmap(double height, double width, {String text}) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = Colors.orange;

    // Marker rectangle (background)
    canvas.drawRect(
      Rect.fromCenter(center: Offset(width / 2, height / 2), width: width, height: height),
      paint1,
    );

    // Expense amount text
    if (text != null) {
      TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);

      // Text font and style
      textPainter.text = TextSpan(
        text: text,
        style: TextStyle(fontSize: height / 3, color: Colors.white, fontWeight: FontWeight.normal),
      );
      textPainter.layout();

      // Text position relative to background (here - centered)
      textPainter.paint(
        canvas,
        Offset(width / 2 - textPainter.width / 2, height / 2 - textPainter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(width.toInt(), height.toInt());
    final data = await img.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  _updateMarkers(Set<Marker> markers) {
    add(ExpensesMapMarkersUpdated(markers: markers));
  }

  double _getExpensesClusterSum(Cluster<ExpenseItemEntity> cluster) {
    double sum = 0;

    cluster.items.forEach((element) {
      if (element?.type == ExpenseType.outcome) sum += element.amount;
    });

    return sum;
  }
}
