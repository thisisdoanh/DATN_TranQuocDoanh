import 'package:equatable/equatable.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoByMonthYear extends Equatable {
  const PhotoByMonthYear({required this.year, required this.months});
  final int year;
  final List<PhotoByMonth> months;

  @override
  List<Object?> get props => [months, year];

  @override
  String toString() => 'PhotoByMonthYear(month: $months, year: $year)';

  PhotoByMonthYear copyWith({int? year, List<PhotoByMonth>? months}) {
    return PhotoByMonthYear(
      year: year ?? this.year,
      months: months ?? this.months,
    );
  }
}

class PhotoByMonth extends Equatable {
  const PhotoByMonth({
    required this.month,
    required this.monthNumber,
    required this.photos,
    required this.year,
  });
  final String month;
  final int monthNumber;
  final int year;
  final List<AssetEntity> photos;

  @override
  List<Object?> get props => [month, year, monthNumber, photos];

  @override
  String toString() =>
      'PhotoByMonth(month: $month, monthNumber: $monthNumber, photoPaths: $photos)';

  PhotoByMonth copyWith({
    String? month,
    int? monthNumber,
    int? year,
    List<AssetEntity>? photos,
  }) {
    return PhotoByMonth(
      month: month ?? this.month,
      monthNumber: monthNumber ?? this.monthNumber,
      year: year ?? this.year,
      photos: photos ?? this.photos,
    );
  }
}
