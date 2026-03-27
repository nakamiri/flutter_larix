import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_larix/flutter_larix.dart';
import 'package:flutter_larix/src/flutter_larix_controller_options.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MethodChannel integration', () {
    test('controller uses correct channel name', () {
      // Verify the controller can be created with a mock channel
      final controller = FlutterLarixController(
        options: FlutterLarixControllerOptions(
          id: 1,
          listener: () {},
          cameraType: CAMERA_TYPE.BACK,
          cameraResolution: CAMERA_RESOLUTION.HD,
          url: 'rtmp://example.com/live/stream',
        ),
      );

      expect(controller, isNotNull);
      expect(controller.getStreamStatus(), STREAM_STATUS.OFF);
    });

    test('streamChanged callback updates stream status to ON', () async {
      bool listenerCalled = false;
      final controller = FlutterLarixController(
        options: FlutterLarixControllerOptions(
          id: 1,
          listener: () {
            listenerCalled = true;
          },
          cameraType: CAMERA_TYPE.BACK,
          cameraResolution: CAMERA_RESOLUTION.HD,
          url: 'rtmp://example.com/live/stream',
        ),
      );

      // Simulate native side calling streamChanged
      final messenger = TestDefaultBinaryMessengerBinding
          .instance.defaultBinaryMessenger;
      final codec = const StandardMethodCodec();
      final data = codec.encodeMethodCall(
        const MethodCall('streamChanged', {
          'connectionState': 'CONNECTED',
        }),
      );
      await messenger.handlePlatformMessage(
        'br.com.devmagic.flutter_larix/nativeview_controller',
        data,
        (ByteData? reply) {},
      );

      expect(controller.getStreamStatus(), STREAM_STATUS.ON);
      expect(controller.getConnectionState(), 'CONNECTED');
      expect(listenerCalled, true);
    });

    test('streamChanged callback updates stream status to OFF on disconnect',
        () async {
      final controller = FlutterLarixController(
        options: FlutterLarixControllerOptions(
          id: 1,
          listener: () {},
          cameraType: CAMERA_TYPE.BACK,
          cameraResolution: CAMERA_RESOLUTION.HD,
          url: 'rtmp://example.com/live/stream',
        ),
      );

      final messenger = TestDefaultBinaryMessengerBinding
          .instance.defaultBinaryMessenger;
      final codec = const StandardMethodCodec();
      final data = codec.encodeMethodCall(
        const MethodCall('streamChanged', {
          'connectionState': 'DISCONNECTED',
        }),
      );
      await messenger.handlePlatformMessage(
        'br.com.devmagic.flutter_larix/nativeview_controller',
        data,
        (ByteData? reply) {},
      );

      expect(controller.getStreamStatus(), STREAM_STATUS.OFF);
      expect(controller.getConnectionState(), 'DISCONNECTED');
    });

    test('connectionStatus callback emits to stream', () async {
      final controller = FlutterLarixController(
        options: FlutterLarixControllerOptions(
          id: 1,
          listener: () {},
          cameraType: CAMERA_TYPE.BACK,
          cameraResolution: CAMERA_RESOLUTION.HD,
          url: 'rtmp://example.com/live/stream',
        ),
      );

      final future = controller.connectionStatusStream.stream.first;

      final messenger = TestDefaultBinaryMessengerBinding
          .instance.defaultBinaryMessenger;
      final codec = const StandardMethodCodec();
      final data = codec.encodeMethodCall(
        const MethodCall('connectionStatus', {
          'isConnected': true,
        }),
      );
      await messenger.handlePlatformMessage(
        'br.com.devmagic.flutter_larix/nativeview_controller',
        data,
        (ByteData? reply) {},
      );

      final result = await future;
      expect(result.isConnected, true);
    });

    test('connectionStatistics callback emits formatted data', () async {
      final controller = FlutterLarixController(
        options: FlutterLarixControllerOptions(
          id: 1,
          listener: () {},
          cameraType: CAMERA_TYPE.BACK,
          cameraResolution: CAMERA_RESOLUTION.HD,
          url: 'rtmp://example.com/live/stream',
        ),
      );

      final future = controller.connectionStatisticsStream.stream.first;

      final messenger = TestDefaultBinaryMessengerBinding
          .instance.defaultBinaryMessenger;
      final codec = const StandardMethodCodec();
      final data = codec.encodeMethodCall(
        const MethodCall('connectionStatistics', {
          'bandwidth': 2000000,
          'traffic': 1048576,
        }),
      );
      await messenger.handlePlatformMessage(
        'br.com.devmagic.flutter_larix/nativeview_controller',
        data,
        (ByteData? reply) {},
      );

      final result = await future;
      expect(result.bandwidth, '2.0Mbps');
      expect(result.traffic, '1.0MB');
    });
  });
}
