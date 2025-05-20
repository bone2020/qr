import '/appbar/single_appbar/single_appbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'email_verification_page_widget.dart' show EmailVerificationPageWidget;
import 'package:flutter/material.dart';

class EmailVerificationPageModel
    extends FlutterFlowModel<EmailVerificationPageWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Model for SingleAppbar component.
  late SingleAppbarModel singleAppbarModel;
  // State field(s) for EmailVerification widget.
  FocusNode? emailVerificationFocusNode;
  TextEditingController? emailVerificationTextController;
  String? Function(BuildContext, String?)?
      emailVerificationTextControllerValidator;
  String? _emailVerificationTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter valid email address';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Please enter valid email address';
    }
    return null;
  }

  @override
  void initState(BuildContext context) {
    singleAppbarModel = createModel(context, () => SingleAppbarModel());
    emailVerificationTextControllerValidator =
        _emailVerificationTextControllerValidator;
  }

  @override
  void dispose() {
    singleAppbarModel.dispose();
    emailVerificationFocusNode?.dispose();
    emailVerificationTextController?.dispose();
  }
}
