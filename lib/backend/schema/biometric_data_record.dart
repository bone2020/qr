import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class BiometricDataRecord extends FirestoreRecord {
  BiometricDataRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "Name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "UserName" field.
  String? _userName;
  String get userName => _userName ?? '';
  bool hasUserName() => _userName != null;

  // "FrontIDurl" field.
  String? _frontIDurl;
  String get frontIDurl => _frontIDurl ?? '';
  bool hasFrontIDurl() => _frontIDurl != null;

  // "BackIDurl" field.
  String? _backIDurl;
  String get backIDurl => _backIDurl ?? '';
  bool hasBackIDurl() => _backIDurl != null;

  // "DateOfBirth" field.
  String? _dateOfBirth;
  String get dateOfBirth => _dateOfBirth ?? '';
  bool hasDateOfBirth() => _dateOfBirth != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  void _initializeFields() {
    _name = snapshotData['Name'] as String?;
    _userName = snapshotData['UserName'] as String?;
    _frontIDurl = snapshotData['FrontIDurl'] as String?;
    _backIDurl = snapshotData['BackIDurl'] as String?;
    _dateOfBirth = snapshotData['DateOfBirth'] as String?;
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('BiometricData');

  static Stream<BiometricDataRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => BiometricDataRecord.fromSnapshot(s));

  static Future<BiometricDataRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => BiometricDataRecord.fromSnapshot(s));

  static BiometricDataRecord fromSnapshot(DocumentSnapshot snapshot) =>
      BiometricDataRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static BiometricDataRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      BiometricDataRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'BiometricDataRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is BiometricDataRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createBiometricDataRecordData({
  String? name,
  String? userName,
  String? frontIDurl,
  String? backIDurl,
  String? dateOfBirth,
  String? email,
  String? displayName,
  String? photoUrl,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Name': name,
      'UserName': userName,
      'FrontIDurl': frontIDurl,
      'BackIDurl': backIDurl,
      'DateOfBirth': dateOfBirth,
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'uid': uid,
      'created_time': createdTime,
      'phone_number': phoneNumber,
    }.withoutNulls,
  );

  return firestoreData;
}

class BiometricDataRecordDocumentEquality
    implements Equality<BiometricDataRecord> {
  const BiometricDataRecordDocumentEquality();

  @override
  bool equals(BiometricDataRecord? e1, BiometricDataRecord? e2) {
    return e1?.name == e2?.name &&
        e1?.userName == e2?.userName &&
        e1?.frontIDurl == e2?.frontIDurl &&
        e1?.backIDurl == e2?.backIDurl &&
        e1?.dateOfBirth == e2?.dateOfBirth &&
        e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber;
  }

  @override
  int hash(BiometricDataRecord? e) => const ListEquality().hash([
        e?.name,
        e?.userName,
        e?.frontIDurl,
        e?.backIDurl,
        e?.dateOfBirth,
        e?.email,
        e?.displayName,
        e?.photoUrl,
        e?.uid,
        e?.createdTime,
        e?.phoneNumber
      ]);

  @override
  bool isValidKey(Object? o) => o is BiometricDataRecord;
}
