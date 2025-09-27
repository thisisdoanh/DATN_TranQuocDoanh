part of 'similar_bloc.dart';

@freezed
abstract class SimilarState extends BaseState with _$SimilarState {
  const factory SimilarState({
    @Default(PageStatus.Loaded) PageStatus pageStatus,
    String? pageErrorMessage,
    @Default([]) List<List<AssetEntity>> listSetSimilar,
    @Default([]) List<List<AssetEntity>> listSetExact,
    @Default([]) List<AssetEntity> listAssets,
    @Default([]) List<String> listIdsAssetsDelete,
    @Default(0) int indexTab,
  }) = _SimilarState;

  const SimilarState._({
    super.pageStatus = PageStatus.Loaded,
    super.pageErrorMessage,
  });
}
