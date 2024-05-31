import 'package:get/get.dart';
import 'dart:async';

class TimerController extends GetxController {
  var secondsRemaining = 120.obs;
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
    otpCodes();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void resetTimer() {
    secondsRemaining.value = 120;
    startTimer();
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  String getTimerText() {
    int minutes = secondsRemaining.value ~/ 60;
    int seconds = secondsRemaining.value % 60;
    return '${minutes}m:${seconds.toString().padLeft(2, '0')}s';
  }

  void resendOtp() {
    // Implement your resend OTP logic here
  }

  void otpCodes() {
    // Implement your OTP codes logic here
  }
}
