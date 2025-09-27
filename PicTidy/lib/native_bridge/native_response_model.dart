import 'package:flutter/services.dart';

class NativeResponseModel<T> {
  NativeResponseModel({required this.isSuccess, this.data, this.error});

  bool isSuccess = false;
  T? data;
  PlatformException? error;
}
