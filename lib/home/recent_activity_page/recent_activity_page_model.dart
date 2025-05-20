import '/appbar/single_appbar/single_appbar_widget.dart';
import '/common_component/comman_item/comman_item_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'recent_activity_page_widget.dart' show RecentActivityPageWidget;
import 'package:flutter/material.dart';

class RecentActivityPageModel
    extends FlutterFlowModel<RecentActivityPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for SingleAppbar component.
  late SingleAppbarModel singleAppbarModel;
  // Models for commanItem dynamic component.
  late FlutterFlowDynamicModels<CommanItemModel> commanItemModels;

  @override
  void initState(BuildContext context) {
    singleAppbarModel = createModel(context, () => SingleAppbarModel());
    commanItemModels = FlutterFlowDynamicModels(() => CommanItemModel());
  }

  @override
  void dispose() {
    singleAppbarModel.dispose();
    commanItemModels.dispose();
  }
}
