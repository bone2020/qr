import '/appbar/single_appbar/single_appbar_widget.dart';
import '/common_component/comman_item/comman_item_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'recent_activity_page_model.dart';
export 'recent_activity_page_model.dart';

class RecentActivityPageWidget extends StatefulWidget {
  const RecentActivityPageWidget({super.key});

  static String routeName = 'RecentActivityPage';
  static String routePath = '/recentActivityPage';

  @override
  State<RecentActivityPageWidget> createState() =>
      _RecentActivityPageWidgetState();
}

class _RecentActivityPageWidgetState extends State<RecentActivityPageWidget> {
  late RecentActivityPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RecentActivityPageModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              wrapWithModel(
                model: _model.singleAppbarModel,
                updateCallback: () => safeSetState(() {}),
                child: SingleAppbarWidget(
                  title: 'Recent activity',
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    final recentActivity = FFAppState().recentactivity.toList();

                    return ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        0,
                        16.0,
                        0,
                        15.0,
                      ),
                      scrollDirection: Axis.vertical,
                      itemCount: recentActivity.length,
                      separatorBuilder: (_, __) => SizedBox(height: 16.0),
                      itemBuilder: (context, recentActivityIndex) {
                        final recentActivityItem =
                            recentActivity[recentActivityIndex];
                        return wrapWithModel(
                          model: _model.commanItemModels.getModel(
                            recentActivityIndex.toString(),
                            recentActivityIndex,
                          ),
                          updateCallback: () => safeSetState(() {}),
                          child: CommanItemWidget(
                            key: Key(
                              'Key1zt_${recentActivityIndex.toString()}',
                            ),
                            imgAll: recentActivityItem,
                            nameAll: recentActivityItem,
                            dateAll: recentActivityItem,
                            dollerAll: recentActivityItem,
                            massgesAll: recentActivityItem,
                            condition: () {
                              if ('Send' == recentActivityItem.massges) {
                                return FlutterFlowTheme.of(context).success;
                              } else if ('Recieved' ==
                                  recentActivityItem.massges) {
                                return FlutterFlowTheme.of(context).success;
                              } else if ('Cancelled' ==
                                  recentActivityItem.massges) {
                                return FlutterFlowTheme.of(context).error;
                              } else {
                                return FlutterFlowTheme.of(context).primary;
                              }
                            }(),
                            onTapAction: () async {},
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
