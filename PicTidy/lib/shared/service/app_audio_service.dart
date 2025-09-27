// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/foundation.dart';
// import 'package:injectable/injectable.dart';
//
// @singleton
// class AppAudioService {
//    final AudioPlayer _audioPlayer = AudioPlayer();
//
//    Future<void> playSound(String assetPath, {bool loop = false}) async {
//     try {
//       await _audioPlayer.stop();
//       if (loop) {
//         await _audioPlayer.setReleaseMode(ReleaseMode.loop);
//       }
//       await _audioPlayer.play(DeviceFileSource(assetPath));
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error playing sound: $e');
//       }
//     }
//   }
//
//    Future<void> stopSound() async {
//     try {
//       await _audioPlayer.stop();
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error stopping sound: $e');
//       }
//     }
//   }
// }