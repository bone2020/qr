import '/common_component/comman_item/comman_item_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'stastic_widget_widget.dart' show StasticWidgetWidget;
import 'package:flutter/material.dart';

class StasticWidgetModel extends FlutterFlowModel<StasticWidgetWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
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
