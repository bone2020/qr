import '/dailog_box/delete_account_dialog/delete_account_dialog_widget.dart';
import '/dailog_box/logout/logout_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'demo_img_page_widget.dart' show DemoImgPageWidget;
import 'package:flutter/material.dart';

class DemoImgPageModel extends FlutterFlowModel<DemoImgPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Logout component.
  late LogoutModel logoutModel;
  // Model for DeleteAccountDialog component.
  late DeleteAccountDialogModel deleteAccountDialogModel;

  @override
  void initState(BuildContext context) {
    logoutModel = createModel(context, () => LogoutModel());
    deleteAccountDialogModel =
        createModel(context, () => DeleteAccountDialogModel());
  }

  @override
  void dispose() {
    logoutModel.dispose();
    deleteAccountDialogModel.dispose();
  }
}
