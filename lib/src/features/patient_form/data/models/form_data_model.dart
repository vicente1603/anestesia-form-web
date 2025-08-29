import '../../../features.dart';

class FormDataModel extends FormDataEntity {
  FormDataModel({
    super.surgery,
    super.surgeon,
    super.allergies,
    super.diseases,
    super.medications,
    super.smokes,
    super.drugs,
    super.icuHistory,
    super.disabilities,
    super.previousSurgeries,
    super.postOpComplications,
    super.familyAnesthesiaHistory,
  });

  Map<String, dynamic> toMap() => {
    'surgery': surgery,
    'surgeon': surgeon,
    'allergies': allergies,
    'diseases': diseases,
    'medications': medications,
    'smokes': smokes,
    'drugs': drugs,
    'icuHistory': icuHistory,
    'disabilities': disabilities,
    'previousSurgeries': previousSurgeries,
    'postOpComplications': postOpComplications,
    'familyAnesthesiaHistory': familyAnesthesiaHistory,
  };

  factory FormDataModel.fromMap(Map<String, dynamic> map) {
    return FormDataModel(
      surgery: map['surgery'],
      surgeon: map['surgeon'],
      allergies: map['allergies'],
      diseases: map['diseases'],
      medications: map['medications'],
      smokes: map['smokes'],
      drugs: map['drugs'],
      icuHistory: map['icuHistory'],
      disabilities: map['disabilities'],
      previousSurgeries: map['previousSurgeries'],
      postOpComplications: map['postOpComplications'],
      familyAnesthesiaHistory: map['familyAnesthesiaHistory'],
    );
  }
}
