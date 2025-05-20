// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class RecentactivityStruct extends FFFirebaseStruct {
  RecentactivityStruct({
    String? img,
    String? name,
    String? date,
    String? massges,
    String? idname,
    String? dollar,
    int? id,
    String? images,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _img = img,
        _name = name,
        _date = date,
        _massges = massges,
        _idname = idname,
        _dollar = dollar,
        _id = id,
        _images = images,
        super(firestoreUtilData);

  // "img" field.
  String? _img;
  String get img => _img ?? '';
  set img(String? val) => _img = val;

  bool hasImg() => _img != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "date" field.
  String? _date;
  String get date => _date ?? '';
  set date(String? val) => _date = val;

  bool hasDate() => _date != null;

  // "massges" field.
  String? _massges;
  String get massges => _massges ?? '';
  set massges(String? val) => _massges = val;

  bool hasMassges() => _massges != null;

  // "idname" field.
  String? _idname;
  String get idname => _idname ?? '';
  set idname(String? val) => _idname = val;

  bool hasIdname() => _idname != null;

  // "dollar" field.
  String? _dollar;
  String get dollar => _dollar ?? '';
  set dollar(String? val) => _dollar = val;

  bool hasDollar() => _dollar != null;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "images" field.
  String? _images;
  String get images => _images ?? '';
  set images(String? val) => _images = val;

  bool hasImages() => _images != null;

  static RecentactivityStruct fromMap(Map<String, dynamic> data) =>
      RecentactivityStruct(
        img: data['img'] as String?,
        name: data['name'] as String?,
        date: data['date'] as String?,
        massges: data['massges'] as String?,
        idname: data['idname'] as String?,
        dollar: data['dollar'] as String?,
        id: castToType<int>(data['id']),
        images: data['images'] as String?,
      );

  static RecentactivityStruct? maybeFromMap(dynamic data) => data is Map
      ? RecentactivityStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'img': _img,
        'name': _name,
        'date': _date,
        'massges': _massges,
        'idname': _idname,
        'dollar': _dollar,
        'id': _id,
        'images': _images,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'img': serializeParam(
          _img,
          ParamType.String,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'date': serializeParam(
          _date,
          ParamType.String,
        ),
        'massges': serializeParam(
          _massges,
          ParamType.String,
        ),
        'idname': serializeParam(
          _idname,
          ParamType.String,
        ),
        'dollar': serializeParam(
          _dollar,
          ParamType.String,
        ),
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'images': serializeParam(
          _images,
          ParamType.String,
        ),
      }.withoutNulls;

  static RecentactivityStruct fromSerializableMap(Map<String, dynamic> data) =>
      RecentactivityStruct(
        img: deserializeParam(
          data['img'],
          ParamType.String,
          false,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        date: deserializeParam(
          data['date'],
          ParamType.String,
          false,
        ),
        massges: deserializeParam(
          data['massges'],
          ParamType.String,
          false,
        ),
        idname: deserializeParam(
          data['idname'],
          ParamType.String,
          false,
        ),
        dollar: deserializeParam(
          data['dollar'],
          ParamType.String,
          false,
        ),
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        images: deserializeParam(
          data['images'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'RecentactivityStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is RecentactivityStruct &&
        img == other.img &&
        name == other.name &&
        date == other.date &&
        massges == other.massges &&
        idname == other.idname &&
        dollar == other.dollar &&
        id == other.id &&
        images == other.images;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([img, name, date, massges, idname, dollar, id, images]);
}

RecentactivityStruct createRecentactivityStruct({
  String? img,
  String? name,
  String? date,
  String? massges,
  String? idname,
  String? dollar,
  int? id,
  String? images,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    RecentactivityStruct(
      img: img,
      name: name,
      date: date,
      massges: massges,
      idname: idname,
      dollar: dollar,
      id: id,
      images: images,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

RecentactivityStruct? updateRecentactivityStruct(
  RecentactivityStruct? recentactivity, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    recentactivity
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addRecentactivityStructData(
  Map<String, dynamic> firestoreData,
  RecentactivityStruct? recentactivity,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (recentactivity == null) {
    return;
  }
  if (recentactivity.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && recentactivity.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final recentactivityData =
      getRecentactivityFirestoreData(recentactivity, forFieldValue);
  final nestedData =
      recentactivityData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = recentactivity.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getRecentactivityFirestoreData(
  RecentactivityStruct? recentactivity, [
  bool forFieldValue = false,
]) {
  if (recentactivity == null) {
    return {};
  }
  final firestoreData = mapToFirestore(recentactivity.toMap());

  // Add any Firestore field values
  recentactivity.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getRecentactivityListFirestoreData(
  List<RecentactivityStruct>? recentactivitys,
) =>
    recentactivitys
        ?.map((e) => getRecentactivityFirestoreData(e, true))
        .toList() ??
    [];
