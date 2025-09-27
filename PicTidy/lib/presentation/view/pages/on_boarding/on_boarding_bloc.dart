import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../di/di.dart';
import '../../../../shared/common/error_converter.dart';
import '../../../base/base_bloc.dart';
import '../../../base/base_state.dart';
import '../../../base/page_status.dart';
import '../../../router/router.dart';

part 'on_boarding_bloc.freezed.dart';
part 'on_boarding_event.dart';
part 'on_boarding_state.dart';

@injectable
class OnBoardingBloc extends BaseBloc<OnBoardingEvent, OnBoardingState> {
  OnBoardingBloc() : super(const OnBoardingState()) {
    on<OnBoardingEvent>((event, emit) async {
      try {
        switch (event) {
          case _LoadData():
            emit(state.copyWith(pageStatus: PageStatus.Loaded));
            break;

          case _NextPage(value: final value):
            if (value != null) {
              if (value > 3) {
                getIt<AppRouter>().replace(PermissionRoute());
                return;
              }
              emit(state.copyWith(currentIndex: value));
            } else {
              if (state.currentIndex <= 3) {
                emit(state.copyWith(currentIndex: state.currentIndex + 1));
              } else {
                getIt<AppRouter>().replace(PermissionRoute());
              }
            }
        }
      } catch (e, s) {
        handleError(emit, ErrorConverter.convert(e, s));
      }
    });
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }

  final PageController pageController = PageController();
}
