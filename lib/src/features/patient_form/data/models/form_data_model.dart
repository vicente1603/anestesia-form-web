import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:convert/convert.dart';
import '../../../features.dart';

String decryptField(String? cipherTextWithIv) {
  if (cipherTextWithIv == null) return '';

  try {
    final parts = cipherTextWithIv.split(':');
    if (parts.length != 2) return cipherTextWithIv;

    final ivBytes = Uint8List.fromList(hex.decode(parts[0]));
    final cipherBytes = Uint8List.fromList(hex.decode(parts[1]));

    final key = Key.fromUtf8("a1gjklJ1oN2GxRiyzEM1Ou6xQ5P010hK");
    if (key.length != 32) {
      throw ArgumentError('A chave deve ter 32 bytes para AES-256-CBC');
    }

    final iv = IV(ivBytes);

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
    final encrypted = Encrypted(cipherBytes);

    return encrypter.decrypt(encrypted, iv: iv);
  } catch (e) {
    return cipherTextWithIv;
  }
}

class FormDataModel extends FormDataEntity {
  FormDataModel({
    super.surgery,
    super.surgeon,
    super.hospital,
    super.gender,
    super.weight,
    super.height,
    super.hasAllergies,
    super.allergiesDetail,
    super.hasDiseases,
    super.diseasesDetail,
    super.usesMedication,
    super.medicationsDetail,
    super.smokes,
    super.usesDrugs,
    super.drugsDetail,
    super.icuHistory,
    super.icuHistoryDetail,
    super.disabilities,
    super.disabilitiesDetail,
    super.hasPreviousSurgeries,
    super.previousSurgeriesDetail,
    super.postOpComplications,
    super.familyAnesthesiaHistory,
    required super.formId,
    required super.formStatus,
    required super.token,
    required super.createAt,
    required super.updatedAt,
  });

  Map<String, dynamic> toMap() => {
    'surgery': surgery,
    'surgeon': surgeon,
    'hospital': hospital,
    'gender': gender,
    'weight': weight,
    'height': height,
    'hasAllergies': hasAllergies,
    'allergiesDetail': allergiesDetail,
    'hasDiseases': hasDiseases,
    'diseasesDetail': diseasesDetail,
    'usesMedication': usesMedication,
    'medicationsDetail': medicationsDetail,
    'smokes': smokes,
    'usesDrugs': usesDrugs,
    'drugsDetail': drugsDetail,
    'icuHistory': icuHistory,
    'icuHistoryDetail': icuHistoryDetail,
    'disabilities': disabilities,
    'disabilitiesDetail': disabilitiesDetail,
    'hasPreviousSurgeries': hasPreviousSurgeries,
    'previousSurgeriesDetail': previousSurgeriesDetail,
    'postOpComplications': postOpComplications,
    'familyAnesthesiaHistory': familyAnesthesiaHistory,
    'formId': formId,
    'formStatus': formStatus,
    'token': token,
    'createAt': createAt,
    'updatedAt': updatedAt,
  };

  factory FormDataModel.fromMap(Map<String, dynamic> map) {
    return FormDataModel(
      surgery: decryptField(map['surgery']),
      surgeon: decryptField(map['surgeon']),
      hospital: decryptField(map['hospital']),
      gender: decryptField(map['gender']),
      weight: double.tryParse(decryptField(map['weight'])),
      height: double.tryParse(decryptField(map['height'])),
      hasAllergies: map['hasAllergies'] as bool?,
      allergiesDetail: decryptField(map['allergiesDetail']),
      hasDiseases: map['hasDiseases'] as bool?,
      diseasesDetail: decryptField(map['diseasesDetail']),
      usesMedication: map['usesMedication'] as bool?,
      medicationsDetail: decryptField(map['medicationsDetail']),
      smokes: map['smokes'] as bool?,
      usesDrugs: map['usesDrugs'] as bool?,
      drugsDetail: decryptField(map['drugsDetail']),
      icuHistory: map['icuHistory'] as bool?,
      icuHistoryDetail: decryptField(map['icuHistoryDetail']),
      disabilities: map['disabilities'] as bool?,
      disabilitiesDetail: decryptField(map['disabilitiesDetail']),
      hasPreviousSurgeries: map['hasPreviousSurgeries'] as bool?,
      previousSurgeriesDetail: decryptField(map['previousSurgeriesDetail']),
      postOpComplications: decryptField(map['postOpComplications']),
      familyAnesthesiaHistory: decryptField(map['familyAnesthesiaHistory']),
      formId: decryptField(map['formId']),
      formStatus: decryptField(map['formStatus']),
      token: decryptField(map['token']),
      createAt: decryptField(map['createAt'] as String?),
      updatedAt: decryptField(map['updatedAt'] as String?),
    );
  }

  FormDataModel copyWith({
    String? surgery,
    String? surgeon,
    String? hospital,
    String? gender,
    double? weight,
    double? height,
    bool? hasAllergies,
    String? allergiesDetail,
    bool? hasDiseases,
    String? diseasesDetail,
    bool? usesMedication,
    String? medicationsDetail,
    bool? smokes,
    bool? usesDrugs,
    String? drugsDetail,
    bool? icuHistory,
    String? icuHistoryDetail,
    bool? disabilities,
    String? disabilitiesDetail,
    bool? hasPreviousSurgeries,
    String? previousSurgeriesDetail,
    String? postOpComplications,
    String? familyAnesthesiaHistory,
    String? formId,
    String? formStatus,
    String? token,
    String? createAt,
    String? updatedAt,
  }) {
    return FormDataModel(
      surgery: surgery ?? this.surgery,
      surgeon: surgeon ?? this.surgeon,
      hospital: hospital ?? this.hospital,
      gender: gender ?? this.gender,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      hasAllergies: hasAllergies ?? this.hasAllergies,
      allergiesDetail: allergiesDetail ?? this.allergiesDetail,
      hasDiseases: hasDiseases ?? this.hasDiseases,
      diseasesDetail: diseasesDetail ?? this.diseasesDetail,
      usesMedication: usesMedication ?? this.usesMedication,
      medicationsDetail: medicationsDetail ?? this.medicationsDetail,
      smokes: smokes ?? this.smokes,
      usesDrugs: usesDrugs ?? this.usesDrugs,
      drugsDetail: drugsDetail ?? this.drugsDetail,
      icuHistory: icuHistory ?? this.icuHistory,
      icuHistoryDetail: icuHistoryDetail ?? this.icuHistoryDetail,
      disabilities: disabilities ?? this.disabilities,
      disabilitiesDetail: disabilitiesDetail ?? this.disabilitiesDetail,
      hasPreviousSurgeries: hasPreviousSurgeries ?? this.hasPreviousSurgeries,
      previousSurgeriesDetail:
          previousSurgeriesDetail ?? this.previousSurgeriesDetail,
      postOpComplications: postOpComplications ?? this.postOpComplications,
      familyAnesthesiaHistory:
          familyAnesthesiaHistory ?? this.familyAnesthesiaHistory,
      formId: formId ?? this.formId,
      formStatus: formStatus ?? this.formStatus,
      token: token ?? this.token,
      createAt: createAt ?? this.createAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
