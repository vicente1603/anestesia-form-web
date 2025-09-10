class FormDataEntity {
  final String? surgery;
  final String? surgeon;
  final String? hospital;
  final String? gender;
  final double? weight;
  final double? height;
  final bool? hasAllergies;
  final String? allergiesDetail;
  final bool? hasDiseases;
  final String? diseasesDetail;
  final bool? usesMedication;
  final String? medicationsDetail;
  final bool? smokes;
  final bool? usesDrugs;
  final String? drugsDetail;
  final bool? icuHistory;
  final String? icuHistoryDetail;
  final bool? disabilities;
  final String? disabilitiesDetail;
  final bool? hasPreviousSurgeries;
  final String? previousSurgeriesDetail;
  final String? postOpComplications;
  final String? familyAnesthesiaHistory;

  const FormDataEntity({
    this.surgery,
    this.surgeon,
    this.hospital,
    this.gender,
    this.weight,
    this.height,
    this.hasAllergies,
    this.allergiesDetail,
    this.hasDiseases,
    this.diseasesDetail,
    this.usesMedication,
    this.medicationsDetail,
    this.smokes,
    this.usesDrugs,
    this.drugsDetail,
    this.icuHistory,
    this.icuHistoryDetail,
    this.disabilities,
    this.disabilitiesDetail,
    this.hasPreviousSurgeries,
    this.previousSurgeriesDetail,
    this.postOpComplications,
    this.familyAnesthesiaHistory,
  });

  FormDataEntity copyWith({
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
  }) {
    return FormDataEntity(
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
    );
  }
}
