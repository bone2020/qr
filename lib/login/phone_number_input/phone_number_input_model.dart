import '/appbar/single_appbar/single_appbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'phone_number_input_widget.dart' show PhoneNumberInputWidget;
import 'package:flutter/material.dart';

class PhoneNumberInputModel extends FlutterFlowModel<PhoneNumberInputWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Model for SingleAppbar component.
  late SingleAppbarModel singleAppbarModel;
  // State field(s) for PhoneNumberInputverification widget.
  FocusNode? phoneNumberInputverificationFocusNode;
  TextEditingController? phoneNumberInputverificationTextController;
  String? Function(BuildContext, String?)?
      phoneNumberInputverificationTextControllerValidator;

  @override
  void initState(BuildContext context) {
    singleAppbarModel = createModel(context, () => SingleAppbarModel());
  }

  @override
  void dispose() {
    singleAppbarModel.dispose();
    phoneNumberInputverificationFocusNode?.dispose();
    phoneNumberInputverificationTextController?.dispose();
  }
}
