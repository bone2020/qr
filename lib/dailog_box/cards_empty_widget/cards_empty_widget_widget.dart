import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'cards_empty_widget_model.dart';
export 'cards_empty_widget_model.dart';

class CardsEmptyWidgetWidget extends StatefulWidget {
  const CardsEmptyWidgetWidget({super.key});

  @override
  State<CardsEmptyWidgetWidget> createState() => _CardsEmptyWidgetWidgetState();
}

class _CardsEmptyWidgetWidgetState extends State<CardsEmptyWidgetWidget> {
  late CardsEmptyWidgetModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CardsEmptyWidgetModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Container(
              width: 120.0,
              height: 120.0,
              decoration: BoxDecoration(
                color: Color(0xFF4C4000),
                shape: BoxShape.circle,
              ),
              alignment: AlignmentDirectional(0.0, 0.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0.0),
                child: Image.asset(
                  'assets/images/credit-card_1.png',
                  width: 52.0,
                  height: 52.0,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Text(
            'No cards yet',
            maxLines: 1,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'SF UI Font',
                  color: FlutterFlowTheme.of(context).tertiary,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.bold,
                  lineHeight: 1.5,
                ),
          ),
          Text(
            'Your cards list is empty, please go to home and view statistics ',
            textAlign: TextAlign.center,
            maxLines: 2,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'SF UI Font',
                  color: FlutterFlowTheme.of(context).tertiary,
                  fontSize: 17.0,
                  letterSpacing: 0.0,
                  lineHeight: 1.5,
                ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(57.0, 0.0, 57.0, 0.0),
            child: FFButtonWidget(
              onPressed: () {
                print('Button pressed ...');
              },
              text: 'Go to home',
              options: FFButtonOptions(
                width: double.infinity,
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 18.0, 16.0, 18.0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'SF UI Font',
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      fontSize: 18.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
                elevation: 0.0,
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
