// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class ChartdataStruct extends FFFirebaseStruct {
  ChartdataStruct({
    int? id,
    String? xvalue,
    String? yvalue,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _id = id,
        _xvalue = xvalue,
        _yvalue = yvalue,
        super(firestoreUtilData);

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "xvalue" field.
  String? _xvalue;
  String get xvalue => _xvalue ?? '';
  set xvalue(String? val) => _xvalue = val;

  bool hasXvalue() => _xvalue != null;

  // "yvalue" field.
  String? _yvalue;
  String get yvalue => _yvalue ?? '';
  set yvalue(String? val) => _yvalue = val;

  bool hasYvalue() => _yvalue != null;

  static ChartdataStruct fromMap(Map<String, dynamic> data) => ChartdataStruct(
        id: castToType<int>(data['id']),
        xvalue: data['xvalue'] as String?,
        yvalue: data['yvalue'] as String?,
      );

  static ChartdataStruct? maybeFromMap(dynamic data) => data is Map
      ? ChartdataStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'xvalue': _xvalue,
        'yvalue': _yvalue,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'xvalue': serializeParam(
          _xvalue,
          ParamType.String,
        ),
        'yvalue': serializeParam(
          _yvalue,
          ParamType.String,
        ),
      }.withoutNulls;

  static ChartdataStruct fromSerializableMap(Map<String, dynamic> data) =>
      ChartdataStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        xvalue: deserializeParam(
          data['xvalue'],
          ParamType.String,
          false,
        ),
        yvalue: deserializeParam(
          data['yvalue'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ChartdataStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ChartdataStruct &&
        id == other.id &&
        xvalue == other.xvalue &&
        yvalue == other.yvalue;
  }

  @override
  int get hashCode => const ListEquality().hash([id, xvalue, yvalue]);
}

ChartdataStruct createChartdataStruct({
  int? id,
  String? xvalue,
  String? yvalue,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ChartdataStruct(
      id: id,
      xvalue: xvalue,
      yvalue: yvalue,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ChartdataStruct? updateChartdataStruct(
  ChartdataStruct? chartdata, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    chartdata
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addChartdataStructData(
  Map<String, dynamic> firestoreData,
  ChartdataStruct? chartdata,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (chartdata == null) {
    return;
  }
  if (chartdata.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && chartdata.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final chartdataData = getChartdataFirestoreData(chartdata, forFieldValue);
  final nestedData = chartdataData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = chartdata.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getChartdataFirestoreData(
  ChartdataStruct? chartdata, [
  bool forFieldValue = false,
]) {
  if (chartdata == null) {
    return {};
  }
  final firestoreData = mapToFirestore(chartdata.toMap());

  // Add any Firestore field values
  chartdata.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getChartdataListFirestoreData(
  List<ChartdataStruct>? chartdatas,
) =>
    chartdatas?.map((e) => getChartdataFirestoreData(e, true)).toList() ?? [];
