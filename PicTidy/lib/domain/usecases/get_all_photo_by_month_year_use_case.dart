import 'package:injectable/injectable.dart';

import '../entities/photo_by_month_year.dart';
import '../repositories/get_all_photo_by_month_year_repository.dart';
import 'use_case.dart';

@injectable
class GetAllPhotoByMonthYearUseCase
    extends UseCase<void, GetAllPhotoByMonthYearParam> {
  GetAllPhotoByMonthYearUseCase(this._getAllPhotoByMonthYearRepository);

  @override
  Future<List<PhotoByMonthYear>> call({
    required GetAllPhotoByMonthYearParam params,
  }) async {
    return await _getAllPhotoByMonthYearRepository.getAllPhotoByMonthYear();
  }

  final GetAllPhotoByMonthYearRepository _getAllPhotoByMonthYearRepository;
}

class GetAllPhotoByMonthYearParam {
  GetAllPhotoByMonthYearParam();
}
