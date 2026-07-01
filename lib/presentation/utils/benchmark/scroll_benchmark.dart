import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ScrollBenchmark {
  ScrollBenchmark._();

  static bool _running = false;

  static Future<void> run(ScrollController controller) async {
    if (_running) return;
    _running = true;

    try {
      await _run(controller);
    } finally {
      _running = false;
    }
  }

  static Future<void> _run(ScrollController controller) async {
    await Future.delayed(const Duration(seconds: 1));

    final startOffset = controller.offset;
    final maxExtent = controller.position.maxScrollExtent;
    const step = 80.0;
    final frameTimes = <double>[];

    debugPrint('=== SCROLL BENCHMARK START ===');
    debugPrint('Max scroll extent: $maxExtent');

    var offset = 0.0;
    while (offset < maxExtent) {
      offset = (offset + step).clamp(0.0, maxExtent);

      final completer = Completer<void>();
      final stopwatch = Stopwatch()..start();

      controller.jumpTo(offset);

      SchedulerBinding.instance.addPostFrameCallback((_) {
        stopwatch.stop();
        completer.complete();
      });
      SchedulerBinding.instance.ensureVisualUpdate();

      await completer.future;

      final ms = stopwatch.elapsedMicroseconds / 1000.0;
      frameTimes.add(ms);

      if (ms > 16.0) {
        debugPrint('  SLOW @ ${offset.toStringAsFixed(0)}px: ${ms.toStringAsFixed(2)}ms');
      }
    }

    controller.jumpTo(startOffset);

    frameTimes.sort();
    final avg = frameTimes.reduce((a, b) => a + b) / frameTimes.length;
    final p50 = frameTimes[frameTimes.length ~/ 2];
    final p95 = frameTimes[(frameTimes.length * 0.95).floor()];
    final p99 = frameTimes[(frameTimes.length * 0.99).floor()];
    final max = frameTimes.last;
    final slowBuilds = frameTimes.where((t) => t > 16.0).length;

    debugPrint('=== SCROLL BENCHMARK RESULTS ===');
    debugPrint('Frames: ${frameTimes.length}');
    debugPrint('Avg:  ${avg.toStringAsFixed(2)}ms');
    debugPrint('P50:  ${p50.toStringAsFixed(2)}ms');
    debugPrint('P95:  ${p95.toStringAsFixed(2)}ms');
    debugPrint('P99:  ${p99.toStringAsFixed(2)}ms');
    debugPrint('Max:  ${max.toStringAsFixed(2)}ms');
    debugPrint('Slow builds (>16ms): $slowBuilds / ${frameTimes.length}');
    debugPrint('================================');
  }
}
