import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../app_bloc.dart';
import '../../di/di.dart';
import '../../domain/entities/photo_by_month_year.dart';
import '../../domain/repositories/get_all_photo_by_month_year_repository.dart';

@Injectable(as: GetAllPhotoByMonthYearRepository)
class GetAllPhotoByMonthYearRepositoryImpl
    extends GetAllPhotoByMonthYearRepository {
  GetAllPhotoByMonthYearRepositoryImpl();

  @override
  Future<List<PhotoByMonthYear>> getAllPhotoByMonthYear() async {
    final status = await PhotoManager.getPermissionState(
      requestOption: const PermissionRequestOption(),
    );
    if (!status.hasAccess) {
      return [];
    }
    // Get all albums containing images
    final List<AssetPathEntity> listPathImage =
        await PhotoManager.getAssetPathList(
          type: RequestType.image,
          filterOption: FilterOptionGroup(
            imageOption: const FilterOption(
              sizeConstraint: SizeConstraint(ignoreSize: true),
            ),
            orders: [
              const OrderOption(type: OrderOptionType.createDate, asc: false),
            ],
          ),
        );

    if (listPathImage.isEmpty) {
      return []; // Return empty if no image albums found
    }

    final AssetPathEntity assetPathAll = listPathImage.firstWhere(
      (element) => element.isAll == true,
    );

    final int assetCount = await assetPathAll.assetCountAsync;
    if (assetCount == 0) {
      return []; // Skip empty albums
    }
    final List<AssetEntity> photos = await assetPathAll.getAssetListRange(
      start: 0,
      end: assetCount, // Adjust the size as needed
    );

    final photoValid = photos
        .where((photo) => photo.width > 0 && photo.height > 0)
        .toList();

    return _filterPhotosByYear(photoValid);
  }

  List<PhotoByMonthYear> _filterPhotosByYear(List<AssetEntity> photos) {
    final Map<String, List<AssetEntity>> assetsGrouped = {};

    List<PhotoByMonthYear> listPhotosByYear = [];

    for (final photo in photos) {
      final date = photo.createDateTime;
      final key = '${date.year}-${date.month.toString().padLeft(2, '0')}';
      assetsGrouped.putIfAbsent(key, () => []).add(photo);
    }

    final Map<int, List<PhotoByMonth>> groupedByYear = {};

    for (final entry in assetsGrouped.entries) {
      final key = entry.key;
      final parts = key.split('-');

      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);

      final date = DateTime(year, month); // Chỉ cần tháng là đủ
      final String monthInString = DateFormat.MMMM(
        getIt<AppBloc>().state.currentLanguage.languageCode,
      ).format(date); // Ex: "May"

      final assets = entry.value;

      final photoByMonth = PhotoByMonth(
        month: monthInString,
        monthNumber: month,
        photos: assets,
        year: year,
      );

      groupedByYear.putIfAbsent(year, () => []).add(photoByMonth);
    }

    listPhotosByYear = groupedByYear.entries
        .map((entry) => PhotoByMonthYear(year: entry.key, months: entry.value))
        .toList();

    listPhotosByYear.sort((a, b) => b.year.compareTo(a.year));

    for (final photoByYear in listPhotosByYear) {
      photoByYear.months.sort((a, b) => b.monthNumber.compareTo(a.monthNumber));
    }

    return listPhotosByYear;
  }
}
