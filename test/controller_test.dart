import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_larix/flutter_larix.dart';
import 'package:flutter_larix/src/flutter_larix_controller_options.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FlutterLarixController controller;
  late List<MethodCall> methodCalls;

  setUp(() {
    methodCalls = [];

    controller = FlutterLarixController(
      options: FlutterLarixControllerOptions(
        id: 1,
        listener: () {},
        cameraType: CAMERA_TYPE.BACK,
        cameraResolution: CAMERA_RESOLUTION.HD,
        url: 'rtmp://example.com/live/stream',
      ),
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel(
          'br.com.devmagic.flutter_larix/nativeview_controller'),
      (MethodCall call) async {
        methodCalls.add(call);
        switch (call.method) {
          case 'initCamera':
            return 'initialized';
          case 'getBitRate':
            return 2000000;
          case 'isRecording':
            return false;
          case 'startRecord':
            return '/path/to/recording.mp4';
          case 'getRotatePermission':
            return true;
          case 'setZoom':
            return 2.5;
          case 'getZoomMax':
            return 10.0;
          case 'toggleTorch':
            return 'true';
          case 'startAudioCapture':
            return {'mute': false};
          case 'stopAudioCapture':
            return {'mute': true};
          case 'getPermissions':
            return {
              'hasAudioPermission': true,
              'hasCameraPermission': true,
            };
          case 'requestPermissions':
            return {
              'hasAudioPermission': true,
              'hasCameraPermission': true,
            };
          case 'setFocus':
            return {
              'isAutoFocus': call.arguments['isAutoFocus'],
              'distanceFocus': call.arguments['distanceFocus'],
            };
          case 'getCameraInfo':
            return [
              {
                'minimumFocusDistance': 0.5,
                'isTorchSupported': true,
                'maxZoom': 10.0,
                'isZoomSupported': true,
                'maxExposure': 4,
                'minExposure': -4,
                'lensFacing': 1,
                'cameraId': '0',
              }
            ];
          default:
            return null;
        }
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel(
          'br.com.devmagic.flutter_larix/nativeview_controller'),
      null,
    );
  });

  group('Initial state', () {
    test('stream status is OFF by default', () {
      expect(controller.getStreamStatus(), STREAM_STATUS.OFF);
    });

    test('microphone status is false by default', () {
      expect(controller.getMicrophoneStatus(), false);
    });

    test('connection state is empty by default', () {
      expect(controller.getConnectionState(), '');
    });

    test('torch is off by default', () {
      expect(controller.getTorchIsOn(), false);
    });
  });

  group('updateAudioStatusCapture', () {
    test('sets mute to true when mute is true', () {
      controller.updateAudioStatusCapture({'mute': true});
      expect(controller.getMicrophoneStatus(), true);
    });

    test('sets mute to false when mute is false', () {
      controller.updateAudioStatusCapture({'mute': false});
      expect(controller.getMicrophoneStatus(), false);
    });

    test('sets mute to false when mute key is missing', () {
      controller.updateAudioStatusCapture({'mute': null});
      expect(controller.getMicrophoneStatus(), false);
    });
  });

  group('bandwidthToString', () {
    test('returns bps for values under 1000', () {
      expect(controller.bandwidthToString(500), '5.0e+2bps');
    });

    test('returns bps for small values', () {
      expect(controller.bandwidthToString(50), '50.bps');
    });

    test('returns Kbps for values in thousands', () {
      expect(controller.bandwidthToString(5000), '5.0Kbps');
    });

    test('returns Kbps for 999999', () {
      final result = controller.bandwidthToString(999999);
      expect(result.endsWith('Kbps'), true);
    });

    test('returns Mbps for values in millions', () {
      expect(controller.bandwidthToString(5000000), '5.0Mbps');
    });

    test('returns Gbps for values in billions', () {
      expect(controller.bandwidthToString(2000000000), '2.0Gbps');
    });
  });

  group('trafficToString', () {
    test('returns B for values under 1024', () {
      expect(controller.trafficToString(500), '500B');
    });

    test('returns B for zero', () {
      expect(controller.trafficToString(0), '0B');
    });

    test('returns KB for values in kilobytes', () {
      expect(controller.trafficToString(5120), '5.0KB');
    });

    test('returns MB for values in megabytes', () {
      expect(controller.trafficToString(5242880), '5.0MB');
    });

    test('returns GB for values in gigabytes', () {
      expect(controller.trafficToString(2147483648), '2.0GB');
    });
  });

  group('Method channel calls', () {
    test('initCamera sends correct method', () async {
      final result = await controller.initCamera(2000000);
      expect(result, 'initialized');
      expect(methodCalls.last.method, 'initCamera');
      expect(methodCalls.last.arguments, 2000000);
    });

    test('disposeCamera sends correct method', () async {
      await controller.disposeCamera();
      expect(methodCalls.last.method, 'disposeCamera');
    });

    test('getBitRate returns value from platform', () async {
      final result = await controller.getBitRate();
      expect(result, 2000000);
    });

    test('setBitRate sends correct arguments', () async {
      await controller.setBitRate(4000000);
      expect(methodCalls.last.method, 'setBitRate');
      expect(methodCalls.last.arguments, 4000000);
    });

    test('isRecording returns value from platform', () async {
      final result = await controller.isRecording();
      expect(result, false);
    });

    test('startRecord sends filename and returns path', () async {
      final result = await controller.startRecord('test_video');
      expect(result, '/path/to/recording.mp4');
      expect(methodCalls.last.arguments, 'test_video');
    });

    test('stopRecord sends correct method', () async {
      await controller.stopRecord();
      expect(methodCalls.last.method, 'stopRecord');
    });

    test('flipCamera sends correct method', () async {
      await controller.flipCamera();
      expect(methodCalls.last.method, 'flipCamera');
    });

    test('setZoom sends correct arguments', () async {
      final result = await controller.setZoom(2.5, true);
      expect(result, 2.5);
      expect(methodCalls.last.arguments, {'zoom': 2.5, 'isManual': true});
    });

    test('getZoomMax returns value from platform', () async {
      final result = await controller.getZoomMax();
      expect(result, 10.0);
    });

    test('toggleTorch updates torch state', () async {
      expect(controller.getTorchIsOn(), false);
      await controller.toggleTorch();
      expect(controller.getTorchIsOn(), true);
    });

    test('startAudioCapture updates mute status', () async {
      final result = await controller.startAudioCapture();
      expect(result, false);
      expect(controller.getMicrophoneStatus(), false);
    });

    test('stopAudioCapture updates mute status', () async {
      final result = await controller.stopAudioCapture();
      expect(result, true);
      expect(controller.getMicrophoneStatus(), true);
    });

    test('getPermissions returns Permissions model', () async {
      final result = await controller.getPermissions();
      expect(result.hasAudioPermission, true);
      expect(result.hasCameraPermission, true);
    });

    test('requestPermissions returns Permissions model', () async {
      final result = await controller.requestPermissions();
      expect(result.hasAudioPermission, true);
      expect(result.hasCameraPermission, true);
    });

    test('setFocus returns FocusModel', () async {
      final result = await controller.setFocus(true, 0.0);
      expect(result.isAutoFocus, true);
      expect(result.distanceFocus, 0.0);
    });

    test('getCameraInfo returns list of CameraInfoModel', () async {
      final result = await controller.getCameraInfo();
      expect(result.length, 1);
      expect(result.first.cameraId, '0');
      expect(result.first.maxZoom, 10.0);
      expect(result.first.isTorchSupported, true);
    });

    test('setDisplayRotation sends correct arguments', () async {
      await controller.setDisplayRotation(90);
      expect(methodCalls.last.method, 'setDisplayRotation');
      expect(methodCalls.last.arguments, 90);
    });

    test('reconnect sends correct method', () async {
      await controller.reconnect();
      expect(methodCalls.last.method, 'reconnect');
    });

    test('getRotatePermission returns value from platform', () async {
      final result = await controller.getRotatePermission();
      expect(result, true);
    });

    test('startVideoCapture sends correct method', () async {
      await controller.startVideoCapture();
      expect(methodCalls.last.method, 'startVideoCapture');
    });

    test('stopVideoCapture sends correct method', () async {
      await controller.stopVideoCapture();
      expect(methodCalls.last.method, 'stopVideoCapture');
    });

    test('startAutomaticBitRate sends correct arguments', () async {
      await controller.startAutomaticBitRate(3000000);
      expect(methodCalls.last.method, 'startAutomaticBitRate');
      expect(methodCalls.last.arguments, 3000000);
    });

    test('stopAutomaticBitRate sends correct method', () async {
      await controller.stopAutomaticBitRate();
      expect(methodCalls.last.method, 'stopAutomaticBitRate');
    });

    test('stopStream sends correct method', () async {
      await controller.stopStream();
      expect(methodCalls.last.method, 'stopStream');
    });
  });

  group('connectionStatisticsStream', () {
    test('emits formatted statistics', () async {
      final future =
          controller.connectionStatisticsStream.stream.first;

      controller.connectionStatistics({
        'bandwidth': 5000000,
        'traffic': 5242880,
      });

      final result = await future;
      expect(result.bandwidth, '5.0Mbps');
      expect(result.traffic, '5.0MB');
    });

    test('emits formatted statistics for small values', () async {
      final future =
          controller.connectionStatisticsStream.stream.first;

      controller.connectionStatistics({
        'bandwidth': 500,
        'traffic': 512,
      });

      final result = await future;
      expect(result.bandwidth.endsWith('bps'), true);
      expect(result.traffic, '512B');
    });
  });
}
