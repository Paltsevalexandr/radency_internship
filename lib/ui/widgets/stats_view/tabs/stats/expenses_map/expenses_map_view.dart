import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:radency_internship_project_2/blocs/stats/expenses_map/expenses_map_bloc.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

class ExpensesMapView extends StatefulWidget {
  @override
  _ExpensesMapViewState createState() => _ExpensesMapViewState();
}

class _ExpensesMapViewState extends State<ExpensesMapView> {
  CameraPosition _cameraPosition;
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExpensesMapBloc, ExpensesMapState>(listener: (context, state) {
      if (state.shouldAnimateToPosition) {
        _animateCamera(state.animateTargetPosition);
      }
    }, builder: (context, state) {
      if (state.isMapInitialized) {

        print("_ExpensesMapViewState.build: ${state.markers.length}");

        return Expanded(
          child: Stack(
            children: [
              GoogleMap(
                onMapCreated: (GoogleMapController controller) async {
                  _controller.complete(controller);
                  _cameraPosition = state.initialCameraPosition;
                  context.read<ExpensesMapBloc>().add(ExpensesMapCreated(controller: controller));
                },
                onCameraMove: (cameraPosition) {
                  _cameraPosition = cameraPosition;

                  context.read<ExpensesMapBloc>().add(ExpensesMapOnCameraMoved(cameraPosition: cameraPosition));
                },
                onCameraIdle: () {
                  context.read<ExpensesMapBloc>().add(ExpensesMapOnCameraMoveEnded());
                },
                zoomControlsEnabled: false,
                initialCameraPosition: state.initialCameraPosition,
                markers: state.markers,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: _fabs(),
              ),
            ],
          ),
        );
      }

      return SizedBox();
    });
  }

  Widget _fabs() {
    return BlocBuilder<ExpensesMapBloc, ExpensesMapState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.all(pixelsToDP(context, 16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              state.isFocusing
                  ? FloatingActionButton(
                      onPressed: null,
                      backgroundColor: Theme.of(context).disabledColor,
                      child: CircularProgressIndicator(),
                    )
                  : FloatingActionButton(
                      onPressed: () {
                        context.read<ExpensesMapBloc>().add(ExpensesMapCurrentLocationPressed());
                      },
                      child: Icon(Icons.my_location),
                    ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _animateCamera(LatLng latLng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: latLng, zoom: 17)));
  }
}
