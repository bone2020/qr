import '/common_component/comman_item/comman_item_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_charts.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'stastic_widget_model.dart';
export 'stastic_widget_model.dart';

class StasticWidgetWidget extends StatefulWidget {
  const StasticWidgetWidget({super.key});

  @override
  State<StasticWidgetWidget> createState() => _StasticWidgetWidgetState();
}

class _StasticWidgetWidgetState extends State<StasticWidgetWidget>
    with TickerProviderStateMixin {
  late StasticWidgetModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StasticWidgetModel());

    animationsMap.addAll({
      'textOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 50.0.ms,
            duration: 2000.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 50.0.ms,
            duration: 500.0.ms,
            begin: Offset(0.0, -50.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryText,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0),
              child: Text(
                'Statistics',
                textAlign: TextAlign.center,
                maxLines: 1,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'SF UI Font',
                      color: FlutterFlowTheme.of(context).tertiary,
                      fontSize: 22.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                      lineHeight: 1.5,
                    ),
              ).animateOnPageLoad(animationsMap['textOnPageLoadAnimation']!),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).darkInput,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          16.0, 18.0, 16.0, 14.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Statistics',
                                      maxLines: 1,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'SF UI Font',
                                            color: FlutterFlowTheme.of(context)
                                                .gray400,
                                            fontSize: 18.0,
                                            letterSpacing: 0.0,
                                            lineHeight: 1.5,
                                          ),
                                    ),
                                    Text(
                                      'Monthly spending',
                                      maxLines: 1,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'SF UI Font',
                                            color: FlutterFlowTheme.of(context)
                                                .tertiary,
                                            fontSize: 18.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            lineHeight: 1.5,
                                          ),
                                    ),
                                  ].divide(SizedBox(height: 8.0)),
                                ),
                              ),
                              FlutterFlowDropDown<String>(
                                controller: _model.dropDownValueController ??=
                                    FormFieldController<String>(null),
                                options: ['Monthly', 'Yearly', 'Weekly'],
                                onChanged: (val) => safeSetState(
                                    () => _model.dropDownValue = val),
                                width: 150.0,
                                height: 50.0,
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'SF UI Font',
                                      color:
                                          FlutterFlowTheme.of(context).tertiary,
                                      fontSize: 15.0,
                                      letterSpacing: 0.0,
                                      lineHeight: 1.5,
                                    ),
                                hintText: 'Monthly',
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: FlutterFlowTheme.of(context).tertiary,
                                  size: 24.0,
                                ),
                                fillColor: Color(0xFF3C3C3C),
                                elevation: 2.0,
                                borderColor: Colors.transparent,
                                borderWidth: 2.0,
                                borderRadius: 8.0,
                                margin: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 2.0, 16.0, 2.0),
                                hidesUnderline: true,
                                isOverButton: true,
                                isSearchable: false,
                                isMultiSelect: false,
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 12.0, 16.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              height: 1.0,
                              decoration: BoxDecoration(
                                color:
                                    FlutterFlowTheme.of(context).darkBoxColor,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 20.0, 0.0, 0.0),
                            child: Container(
                              width: 396.0,
                              height: 183.0,
                              child: FlutterFlowBarChart(
                                barData: [
                                  FFBarChartData(
                                    yData: FFAppState()
                                        .chartdata
                                        .map((e) => e.yvalue)
                                        .toList(),
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                                  FFBarChartData(
                                    yData: FFAppState()
                                        .chartdata
                                        .map((e) => e.yvalue)
                                        .toList(),
                                    color: Color(0xFF4C4000),
                                  )
                                ],
                                xLabels: FFAppState()
                                    .chartdata
                                    .map((e) => e.xvalue)
                                    .toList(),
                                barWidth: 26.0,
                                barBorderRadius: BorderRadius.circular(7.0),
                                barSpace: 5.0,
                                groupSpace: 21.0,
                                alignment: BarChartAlignment.spaceAround,
                                chartStylingInfo: ChartStylingInfo(
                                  backgroundColor:
                                      FlutterFlowTheme.of(context).darkInput,
                                  showGrid: true,
                                  borderColor: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  borderWidth: 1.0,
                                ),
                                axisBounds: AxisBounds(
                                  maxY: 30.0,
                                ),
                                xAxisLabelInfo: AxisLabelInfo(
                                  showLabels: true,
                                  labelTextStyle: TextStyle(
                                    fontFamily: 'SF UI Font',
                                    color: FlutterFlowTheme.of(context).gray400,
                                    fontSize: 12.0,
                                  ),
                                  labelInterval: 10.0,
                                  reservedSize: 28.0,
                                ),
                                yAxisLabelInfo: AxisLabelInfo(
                                  showLabels: true,
                                  labelTextStyle: TextStyle(
                                    fontFamily: 'SF UI Font',
                                    color: FlutterFlowTheme.of(context).gray400,
                                    fontSize: 14.0,
                                  ),
                                  labelInterval: 10.0,
                                  reservedSize: 42.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent activity',
                        maxLines: 1,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'SF UI Font',
                              color: FlutterFlowTheme.of(context).tertiary,
                              fontSize: 18.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              lineHeight: 1.5,
                            ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          context.pushNamed(RecentActivityPageWidget.routeName);
                        },
                        child: Text(
                          'View all',
                          maxLines: 1,
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'SF UI Font',
                                color: FlutterFlowTheme.of(context).tertiary,
                                fontSize: 15.0,
                                letterSpacing: 0.0,
                                lineHeight: 1.5,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                Builder(
                  builder: (context) {
                    final statistics =
                        FFAppState().recentactivity.toList().take(3).toList();

                    return ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        0,
                        0,
                        0,
                        20.0,
                      ),
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: statistics.length,
                      separatorBuilder: (_, __) => SizedBox(height: 16.0),
                      itemBuilder: (context, statisticsIndex) {
                        final statisticsItem = statistics[statisticsIndex];
                        return wrapWithModel(
                          model: _model.commanItemModels.getModel(
                            statisticsIndex.toString(),
                            statisticsIndex,
                          ),
                          updateCallback: () => safeSetState(() {}),
                          child: CommanItemWidget(
                            key: Key(
                              'Keyrkq_${statisticsIndex.toString()}',
                            ),
                            imgAll: statisticsItem,
                            nameAll: statisticsItem,
                            dateAll: statisticsItem,
                            dollerAll: statisticsItem,
                            massgesAll: statisticsItem,
                            condition: () {
                              if ('Send' == statisticsItem.massges) {
                                return FlutterFlowTheme.of(context).success;
                              } else if ('Recieved' == statisticsItem.massges) {
                                return FlutterFlowTheme.of(context).success;
                              } else if ('Cancelled' ==
                                  statisticsItem.massges) {
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
              ],
            ),
          ),
        ].addToStart(SizedBox(height: 74.0)),
      ),
    );
  }
}
