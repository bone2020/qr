import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'biometric_widget.dart' show BiometricWidget;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BiometricModel extends FlutterFlowModel<BiometricWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for FullNameFieldBIO widget.
  FocusNode? fullNameFieldBIOFocusNode;
  TextEditingController? fullNameFieldBIOTextController;
  String? Function(BuildContext, String?)?
      fullNameFieldBIOTextControllerValidator;
  String? _fullNameFieldBIOTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter valid full  name';
    }

    return null;
  }

  // State field(s) for UserNameFieldBIO widget.
  FocusNode? userNameFieldBIOFocusNode;
  TextEditingController? userNameFieldBIOTextController;
  String? Function(BuildContext, String?)?
      userNameFieldBIOTextControllerValidator;
  String? _userNameFieldBIOTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter valid username';
    }

    return null;
  }

  // State field(s) for EmailFieldBIO widget.
  FocusNode? emailFieldBIOFocusNode;
  TextEditingController? emailFieldBIOTextController;
  String? Function(BuildContext, String?)? emailFieldBIOTextControllerValidator;
  String? _emailFieldBIOTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter valid email address';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Has to be a valid email address.';
    }
    return null;
  }

  // State field(s) for PhoneNumberBIO widget.
  FocusNode? phoneNumberBIOFocusNode;
  TextEditingController? phoneNumberBIOTextController;
  String? Function(BuildContext, String?)?
      phoneNumberBIOTextControllerValidator;
  String? _phoneNumberBIOTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return '+233 is required';
    }

    return null;
  }

  // State field(s) for PasswordFieldBIO widget.
  FocusNode? passwordFieldBIOFocusNode;
  TextEditingController? passwordFieldBIOTextController;
  late bool passwordFieldBIOVisibility;
  String? Function(BuildContext, String?)?
      passwordFieldBIOTextControllerValidator;
  String? _passwordFieldBIOTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return '1234 is required';
    }

    return null;
  }

  // State field(s) for DropDownBIO widget.
  String? dropDownBIOValue;
  FormFieldController<String>? dropDownBIOValueController;
  bool isDataUploading1 = false;
  FFUploadedFile uploadedLocalFile1 =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  bool isDataUploading2 = false;
  FFUploadedFile uploadedLocalFile2 =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  DateTime? datePicked;
  bool isDataUploading3 = false;
  FFUploadedFile uploadedLocalFile3 =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl3 = '';

  bool isDataUploading4 = false;
  FFUploadedFile uploadedLocalFile4 =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl4 = '';

  @override
  void initState(BuildContext context) {
    fullNameFieldBIOTextControllerValidator =
        _fullNameFieldBIOTextControllerValidator;
    userNameFieldBIOTextControllerValidator =
        _userNameFieldBIOTextControllerValidator;
    emailFieldBIOTextControllerValidator =
        _emailFieldBIOTextControllerValidator;
    phoneNumberBIOTextControllerValidator =
        _phoneNumberBIOTextControllerValidator;
    passwordFieldBIOVisibility = false;
    passwordFieldBIOTextControllerValidator =
        _passwordFieldBIOTextControllerValidator;
  }

  @override
  void dispose() {
    fullNameFieldBIOFocusNode?.dispose();
    fullNameFieldBIOTextController?.dispose();

    userNameFieldBIOFocusNode?.dispose();
    userNameFieldBIOTextController?.dispose();

    emailFieldBIOFocusNode?.dispose();
    emailFieldBIOTextController?.dispose();

    phoneNumberBIOFocusNode?.dispose();
    phoneNumberBIOTextController?.dispose();

    passwordFieldBIOFocusNode?.dispose();
    passwordFieldBIOTextController?.dispose();
  }
}
