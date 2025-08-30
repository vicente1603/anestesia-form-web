import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../features.dart';

class InfoModel extends InfoEntity {
  InfoModel({super.fullName, super.birthDate});

  Map<String, dynamic> toMap() => {
        'full_name': fullName,
        'birthDate': birthDate, 
      };

  factory InfoModel.fromMap(Map<String, dynamic> map) {
    final timestamp = map['birthDate'] as Timestamp?;
    return InfoModel(
      fullName: map['full_name'] as String?,
      birthDate: timestamp?.toDate(), 
    );
  }
}
