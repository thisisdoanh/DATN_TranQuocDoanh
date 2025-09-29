part of 'memory_bloc.dart';

@freezed
abstract class MemoryState extends BaseState with _$MemoryState {
  const factory MemoryState({
    @Default(PageStatus.Loaded) PageStatus pageStatus,
    String? pageErrorMessage,
    @Default([]) List<AssetEntity> listRecent,
    @Default([]) List<AssetEntity> listMemory,
  }) = _MemoryState;

  const MemoryState._({
    super.pageStatus = PageStatus.Loaded,
    super.pageErrorMessage,
  });

}
