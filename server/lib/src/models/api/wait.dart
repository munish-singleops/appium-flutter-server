import 'package:appium_flutter_server/src/models/api/element.dart';
import 'package:appium_flutter_server/src/models/api/find_element.dart';
import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/utils/flutter_settings.dart';

class WaitModel {
  ElementModel? element;
  FindElementModel? locator;
  Duration? timeout;

  WaitModel({required this.element, required this.locator, this.timeout});

  static int _durationToJson(Duration? value) {
    if (value != null) {
      return value.inSeconds;
    }
    // Use FlutterSettings default if no timeout is provided
    try {
      final timeoutMs =
          FlutterDriver.instance.settings.getSetting(FlutterSettings.flutterElementWaitTimeout);
      return ((timeoutMs ?? 5000) / 1000).round();
    } catch (e) {
      // Fallback to 5 seconds if FlutterDriver is not initialized
      return 5;
    }
  }

  static Duration _durationFromJson(int? value) {
    if (value != null) {
      print('WaitModel: Using provided timeout: ${value} seconds');
      return Duration(seconds: value);
    }
    // Use FlutterSettings default if no timeout is provided
    try {
      final timeoutMs =
          FlutterDriver.instance.settings.getSetting(FlutterSettings.flutterElementWaitTimeout);
      final duration = Duration(milliseconds: timeoutMs ?? 5000);
      print(
          'WaitModel: Using FlutterSettings timeout: ${duration.inSeconds} seconds (${timeoutMs}ms)');
      return duration;
    } catch (e) {
      // Fallback to 5 seconds if FlutterDriver is not initialized
      print('WaitModel: Using fallback timeout: 5 seconds (FlutterDriver not initialized)');
      return const Duration(milliseconds: 5000);
    }
  }

  factory WaitModel.fromJson(Map<String, dynamic> json) => WaitModel(
        element: json['element'] == null
            ? null
            : ElementModel.fromJson(json['element'] as Map<String, dynamic>),
        locator: json['locator'] == null
            ? null
            : FindElementModel.fromJson(json['locator'] as Map<String, dynamic>),
        timeout: WaitModel._durationFromJson((json['timeout'] as num?)?.toInt()),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'element': element,
        'locator': locator,
        'timeout': WaitModel._durationToJson(timeout),
      };
}
