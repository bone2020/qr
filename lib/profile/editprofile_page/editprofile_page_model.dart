import '/appbar/single_appbar/single_appbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'editprofile_page_widget.dart' show EditprofilePageWidget;
import 'package:flutter/material.dart';

class EditprofilePageModel extends FlutterFlowModel<EditprofilePageWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Model for SingleAppbar component.
  late SingleAppbarModel singleAppbarModel;
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  // State field(s) for ProfileName widget.
  FocusNode? profileNameFocusNode;
  TextEditingController? profileNameTextController;
  String? Function(BuildContext, String?)? profileNameTextControllerValidator;
  String? _profileNameTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter valid name';
    }

    return null;
  }

  // State field(s) for EmailVerification widget.
  FocusNode? emailVerificationFocusNode;
  TextEditingController? emailVerificationTextController;
  String? Function(BuildContext, String?)?
      emailVerificationTextControllerValidator;
  String? _emailVerificationTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Email address is required';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Has to be a valid email address.';
    }
    return null;
  }

  // State field(s) for PhoneNumberInputverification widget.
  FocusNode? phoneNumberInputverificationFocusNode;
  TextEditingController? phoneNumberInputverificationTextController;
  String? Function(BuildContext, String?)?
      phoneNumberInputverificationTextControllerValidator;
  String? _phoneNumberInputverificationTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Phone Number is required';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    singleAppbarModel = createModel(context, () => SingleAppbarModel());
    profileNameTextControllerValidator = _profileNameTextControllerValidator;
    emailVerificationTextControllerValidator =
        _emailVerificationTextControllerValidator;
    phoneNumberInputverificationTextControllerValidator =
        _phoneNumberInputverificationTextControllerValidator;
  }

  @override
  void dispose() {
    singleAppbarModel.dispose();
    profileNameFocusNode?.dispose();
    profileNameTextController?.dispose();

    emailVerificationFocusNode?.dispose();
    emailVerificationTextController?.dispose();

    phoneNumberInputverificationFocusNode?.dispose();
    phoneNumberInputverificationTextController?.dispose();
  }
}
