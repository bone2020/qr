import '/common_component/comman_item/comman_item_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_widget_widget.dart' show HomeWidgetWidget;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeWidgetModel extends FlutterFlowModel<HomeWidgetWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Carousel widget.
  CarouselSliderController? carouselController;
  int carouselCurrentIndex = 1;

  // Models for commanItem dynamic component.
  late FlutterFlowDynamicModels<CommanItemModel> commanItemModels;

  @override
  void initState(BuildContext context) {
    commanItemModels = FlutterFlowDynamicModels(() => CommanItemModel());
  }

  @override
  void dispose() {
    commanItemModels.dispose();
  }
}
