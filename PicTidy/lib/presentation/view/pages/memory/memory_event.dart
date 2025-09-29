part of 'memory_bloc.dart';

@freezed
sealed class MemoryEvent with _$MemoryEvent {
  const factory MemoryEvent.loadData() = _LoadData;
  const factory MemoryEvent.memory() = _Memory;
  const factory MemoryEvent.recent() = _Recent;
  const factory MemoryEvent.random() = _Random;
  const factory MemoryEvent.onPressMonth(PhotoByMonth album) = _OnPressMonth;

  const factory MemoryEvent.onPressAnything() = _OnPressAnything;
  const factory MemoryEvent.onPressScreenshots() = _OnPressScreenshots;
  const factory MemoryEvent.onPressPhoto() = _OnPressPhoto;
}
