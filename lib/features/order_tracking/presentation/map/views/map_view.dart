import 'package:flowery_rider/features/order_tracking/presentation/map/view_model/cubit/map_cubit.dart';
import 'package:flowery_rider/features/order_tracking/presentation/map/view_model/state/map_state.dart';
import 'package:flowery_rider/features/order_tracking/presentation/map/widgets/map_back_button.dart';
import 'package:flowery_rider/features/order_tracking/presentation/map/widgets/map_details_bottom_sheet.dart';
import 'package:flowery_rider/features/order_tracking/presentation/map/widgets/route_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MapCubit, MapState>(
        builder: (context, state) {
          final routePoint = state.routePoint;

          return Stack(
            children: [
              if (routePoint != null) RouteMap(state: state),
              if (routePoint == null || state.isLoading)
                Center(
                  child: SpinKitFadingCircle(
                    color: Theme.of(context).colorScheme.primary,
                    size: 50,
                  ),
                ),
              const MapBackButton(),
              if (routePoint != null)
                DraggableScrollableSheet(
                  initialChildSize: 0.35,
                  minChildSize: 0.20,
                  maxChildSize: 0.35,
                  builder: (context, scrollController) {
                    return MapDetailsBottomSheet(
                      order: routePoint.order,
                      type: routePoint.type,
                      scrollController: scrollController,
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
