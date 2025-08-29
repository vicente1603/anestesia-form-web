class FormDataEntity {
  final String? surgery;
  final String? surgeon;
  final String? allergies;
  final String? diseases;
  final String? medications;
  final String? smokes;
  final String? drugs;
  final String? icuHistory;
  final String? disabilities;
  final String? previousSurgeries;
  final String? postOpComplications;
  final String? familyAnesthesiaHistory;

  const FormDataEntity({
    this.surgery,
    this.surgeon,
    this.allergies,
    this.diseases,
    this.medications,
    this.smokes,
    this.drugs,
    this.icuHistory,
    this.disabilities,
    this.previousSurgeries,
    this.postOpComplications,
    this.familyAnesthesiaHistory,
  });

  FormDataEntity copyWith({
    String? surgery,
    String? surgeon,
    String? allergies,
    String? diseases,
    String? medications,
    String? smokes,
    String? drugs,
    String? icuHistory,
    String? disabilities,
    String? previousSurgeries,
    String? postOpComplications,
    String? familyAnesthesiaHistory,
  }) {
    return FormDataEntity(
      surgery: surgery ?? this.surgery,
      surgeon: surgeon ?? this.surgeon,
      allergies: allergies ?? this.allergies,
      diseases: diseases ?? this.diseases,
      medications: medications ?? this.medications,
      smokes: smokes ?? this.smokes,
      drugs: drugs ?? this.drugs,
      icuHistory: icuHistory ?? this.icuHistory,
      disabilities: disabilities ?? this.disabilities,
      previousSurgeries: previousSurgeries ?? this.previousSurgeries,
      postOpComplications: postOpComplications ?? this.postOpComplications,
      familyAnesthesiaHistory:
          familyAnesthesiaHistory ?? this.familyAnesthesiaHistory,
    );
  }
}
