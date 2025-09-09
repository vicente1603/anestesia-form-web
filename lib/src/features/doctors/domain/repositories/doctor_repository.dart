
import '../../../features.dart';

abstract class DoctorRepository {
  Future<DoctorEntity?> getDoctor(String doctorId);
}
