import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Stream provider that emits device heading (degrees 0-360) using magnetometer
/// with simple smoothing. This uses the magnetometer alone (no tilt
/// compensation) for simplicity — works best when device is roughly flat.
///
/// Smoothing: exponential moving average on angular space to avoid wrap issues.
final sensorHeadingProvider = StreamProvider.autoDispose<double>((ref) {
  const smoothingAlpha = 0.35; // Aumentado de 0.18 para 0.35 para ser mais reativo

  StreamController<double>? controller;
  StreamSubscription<MagnetometerEvent>? sub;

  double? lastSmoothedDegrees;

  void onMag(MagnetometerEvent e) {
    // Compute raw heading (radians) from magnetometer x/y
    // Use atan2(y, x) and convert to degrees, normalize to [0,360)
    final rawRad = math.atan2(e.y, e.x);
    var rawDeg = rawRad * 180 / math.pi;
    if (rawDeg < 0) rawDeg += 360;

    if (lastSmoothedDegrees == null) {
      lastSmoothedDegrees = rawDeg;
    } else {
      // Smooth on circular domain
      final diff = ((rawDeg - lastSmoothedDegrees! + 540) % 360) - 180;
      lastSmoothedDegrees = (lastSmoothedDegrees! + smoothingAlpha * diff) % 360;
      if (lastSmoothedDegrees! < 0) lastSmoothedDegrees = lastSmoothedDegrees! + 360;
    }

    controller?.add(lastSmoothedDegrees!);
  }

  controller = StreamController<double>(onListen: () {
    sub = magnetometerEvents.listen(onMag, onError: (e, st) {
      controller?.addError(e, st);
    });
  }, onCancel: () async {
    await sub?.cancel();
    await controller?.close();
  });

  ref.onDispose(() async {
    await sub?.cancel();
    await controller?.close();
  });

  return controller.stream;
});
