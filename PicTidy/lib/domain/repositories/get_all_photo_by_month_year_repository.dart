import '../entities/photo_by_month_year.dart';

abstract class GetAllPhotoByMonthYearRepository {
  Future<List<PhotoByMonthYear>> getAllPhotoByMonthYear();
}
