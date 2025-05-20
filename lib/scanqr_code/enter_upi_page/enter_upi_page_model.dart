import '/appbar/single_appbar/single_appbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'enter_upi_page_widget.dart' show EnterUpiPageWidget;
import 'package:flutter/material.dart';

class EnterUpiPageModel extends FlutterFlowModel<EnterUpiPageWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Model for SingleAppbar component.
  late SingleAppbarModel singleAppbarModel;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  String? _textControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'please enter valid UPI ID or number';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    singleAppbarModel = createModel(context, () => SingleAppbarModel());
    textControllerValidator = _textControllerValidator;
  }

  @override
  void dispose() {
    singleAppbarModel.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
