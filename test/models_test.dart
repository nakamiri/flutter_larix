import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_larix/src/defs/camera_info_model.dart';
import 'package:flutter_larix/src/defs/connection_status.dart';
import 'package:flutter_larix/src/defs/connectionStatistics.dart';
import 'package:flutter_larix/src/defs/connectionStatisticsFormated.dart';
import 'package:flutter_larix/src/defs/focus_model.dart';
import 'package:flutter_larix/src/defs/permissions.dart';
import 'package:flutter_larix/src/defs/stream_changed.dart';

void main() {
  group('CameraInfoModel', () {
    test('fromHashMap creates model correctly', () {
      final data = {
        'minimumFocusDistance': 0.5,
        'isTorchSupported': true,
        'maxZoom': 10.0,
        'isZoomSupported': true,
        'maxExposure': 4,
        'minExposure': -4,
        'lensFacing': 1,
        'cameraId': '0',
      };

      final model = CameraInfoModel.fromHashMap(data);

      expect(model.minimumFocusDistance, 0.5);
      expect(model.isTorchSupported, true);
      expect(model.maxZoom, 10.0);
      expect(model.isZoomSupported, true);
      expect(model.maxExposure, 4);
      expect(model.minExposure, -4);
      expect(model.lensFacing, 1);
      expect(model.cameraId, '0');
    });

    test('fromHashMap with front camera values', () {
      final data = {
        'minimumFocusDistance': 0.0,
        'isTorchSupported': false,
        'maxZoom': 4.0,
        'isZoomSupported': true,
        'maxExposure': 2,
        'minExposure': -2,
        'lensFacing': 0,
        'cameraId': '1',
      };

      final model = CameraInfoModel.fromHashMap(data);

      expect(model.minimumFocusDistance, 0.0);
      expect(model.isTorchSupported, false);
      expect(model.lensFacing, 0);
      expect(model.cameraId, '1');
    });
  });

  group('ConnectionStatusModel', () {
    test('fromJson creates connected model', () {
      final json = HashMap<dynamic, dynamic>.from({
        'isConnected': true,
      });

      final model = ConnectionStatusModel.fromJson(json);

      expect(model.isConnected, true);
    });

    test('fromJson creates disconnected model', () {
      final json = HashMap<dynamic, dynamic>.from({
        'isConnected': false,
      });

      final model = ConnectionStatusModel.fromJson(json);

      expect(model.isConnected, false);
    });
  });

  group('ConnectionStatisticsModel', () {
    test('fromJson creates model correctly', () {
      final json = HashMap<dynamic, dynamic>.from({
        'bandwidth': 5000000,
        'traffic': 1048576,
      });

      final model = ConnectionStatisticsModel.fromJson(json);

      expect(model.bandwidth, 5000000);
      expect(model.traffic, 1048576);
    });

    test('fromJson with zero values', () {
      final json = HashMap<dynamic, dynamic>.from({
        'bandwidth': 0,
        'traffic': 0,
      });

      final model = ConnectionStatisticsModel.fromJson(json);

      expect(model.bandwidth, 0);
      expect(model.traffic, 0);
    });
  });

  group('ConnectionStatisticsFormatedModel', () {
    test('constructor sets values correctly', () {
      final model = ConnectionStatisticsFormatedModel(
        bandwidth: '5.0Mbps',
        traffic: '1.0MB',
      );

      expect(model.bandwidth, '5.0Mbps');
      expect(model.traffic, '1.0MB');
    });
  });

  group('FocusModel', () {
    test('fromHashMap with auto focus', () {
      final data = {
        'isAutoFocus': true,
        'distanceFocus': 0.0,
      };

      final model = FocusModel.fromHashMap(data);

      expect(model.isAutoFocus, true);
      expect(model.distanceFocus, 0.0);
    });

    test('fromHashMap with manual focus', () {
      final data = {
        'isAutoFocus': false,
        'distanceFocus': 3.5,
      };

      final model = FocusModel.fromHashMap(data);

      expect(model.isAutoFocus, false);
      expect(model.distanceFocus, 3.5);
    });
  });

  group('Permissions', () {
    test('fromJson with all permissions granted', () {
      final json = HashMap<dynamic, dynamic>.from({
        'hasAudioPermission': true,
        'hasCameraPermission': true,
      });

      final model = Permissions.fromJson(json);

      expect(model.hasAudioPermission, true);
      expect(model.hasCameraPermission, true);
    });

    test('fromJson with no permissions', () {
      final json = HashMap<dynamic, dynamic>.from({
        'hasAudioPermission': false,
        'hasCameraPermission': false,
      });

      final model = Permissions.fromJson(json);

      expect(model.hasAudioPermission, false);
      expect(model.hasCameraPermission, false);
    });

    test('fromJson with partial permissions', () {
      final json = HashMap<dynamic, dynamic>.from({
        'hasAudioPermission': false,
        'hasCameraPermission': true,
      });

      final model = Permissions.fromJson(json);

      expect(model.hasAudioPermission, false);
      expect(model.hasCameraPermission, true);
    });
  });

  group('StreamChanged', () {
    test('fromJson with CONNECTED state', () {
      final json = HashMap<dynamic, dynamic>.from({
        'connectionState': 'CONNECTED',
      });

      final model = StreamChanged.fromJson(json);

      expect(model.connectionState, 'CONNECTED');
    });

    test('fromJson with DISCONNECTED state', () {
      final json = HashMap<dynamic, dynamic>.from({
        'connectionState': 'DISCONNECTED',
      });

      final model = StreamChanged.fromJson(json);

      expect(model.connectionState, 'DISCONNECTED');
    });
  });
}
