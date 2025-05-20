import '/cards/card_widgets/card_widgets_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/home/home_widget/home_widget_widget.dart';
import '/profile/profile_widget/profile_widget_widget.dart';
import '/statistics/stastic_widget/stastic_widget_widget.dart';
import '/index.dart';
import 'navbar_widget.dart' show NavbarWidget;
import 'package:flutter/material.dart';

class NavbarModel extends FlutterFlowModel<NavbarWidget> {
  ///  Local state fields for this page.

  int? bottomAdd = 0;

  ///  State fields for stateful widgets in this page.

  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // Model for HomeWidget component.
  late HomeWidgetModel homeWidgetModel;
  // Model for StasticWidget component.
  late StasticWidgetModel stasticWidgetModel;
  // Model for CardWidgets component.
  late CardWidgetsModel cardWidgetsModel;
  // Model for ProfileWidget component.
  late ProfileWidgetModel profileWidgetModel;

  @override
  void initState(BuildContext context) {
    homeWidgetModel = createModel(context, () => HomeWidgetModel());
    stasticWidgetModel = createModel(context, () => StasticWidgetModel());
    cardWidgetsModel = createModel(context, () => CardWidgetsModel());
    profileWidgetModel = createModel(context, () => ProfileWidgetModel());
  }

  @override
  void dispose() {
    homeWidgetModel.dispose();
    stasticWidgetModel.dispose();
    cardWidgetsModel.dispose();
    profileWidgetModel.dispose();
  }
}
